import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/repositories/participant_repository.dart';
import '../../../domain/services/turn_service.dart';
import '../../../domain/usecases/add_participant.dart' as add_usecase;
import '../../../domain/usecases/get_participants.dart';
import 'participant_event.dart';
import 'participant_state.dart';

@injectable
class ParticipantBloc extends Bloc<ParticipantEvent, ParticipantState> {
  final GetParticipants getParticipants;
  final add_usecase.AddParticipant addParticipant;
  final ParticipantRepository participantRepository;
  final TurnService turnService;

  ParticipantBloc({
    required this.getParticipants,
    required this.addParticipant,
    required this.participantRepository,
    required this.turnService,
  }) : super(const ParticipantInitial()) {
    on<LoadParticipants>(_onLoadParticipants);
    on<AddParticipant>(_onAddParticipant);
    on<UpdateParticipant>(_onUpdateParticipant);
    on<RemoveParticipant>(_onRemoveParticipant);
    on<ToggleParticipantStatus>(_onToggleParticipantStatus);
    on<ResetTurnCounts>(_onResetTurnCounts);
  }

  Future<void> _onLoadParticipants(
    LoadParticipants event,
    Emitter<ParticipantState> emit,
  ) async {
    emit(const ParticipantLoading());

    final result = await getParticipants(GetParticipantsParams(
      groupId: event.groupId,
      activeOnly: event.activeOnly,
    ));

    result.fold(
      (failure) => emit(ParticipantError(failure.toString())),
      (participants) {
        final statistics = turnService.getTurnStatistics(participants);
        emit(ParticipantLoaded(
          participants: participants,
          statistics: statistics,
        ));
      },
    );
  }

  Future<void> _onAddParticipant(
    AddParticipant event,
    Emitter<ParticipantState> emit,
  ) async {
    emit(const ParticipantLoading());

    final result = await addParticipant(add_usecase.AddParticipantParams(
      groupId: event.groupId,
      participant: event.participant,
    ));

    await result.fold(
      (failure) async => emit(ParticipantError(failure.toString())),
      (participant) async {
        // Reload participants after adding
        final participantsResult = await getParticipants(GetParticipantsParams(
          groupId: event.groupId,
        ));

        participantsResult.fold(
          (failure) => emit(ParticipantError(failure.toString())),
          (participants) {
            emit(ParticipantOperationSuccess(
              message: 'Participant "${participant.name}" added successfully',
              participants: participants,
            ));
          },
        );
      },
    );
  }

  Future<void> _onUpdateParticipant(
    UpdateParticipant event,
    Emitter<ParticipantState> emit,
  ) async {
    try {
      emit(const ParticipantLoading());

      final updatedParticipant =
          await participantRepository.updateParticipant(event.participant);

      // Get current group ID (assuming it's available in state or passed)
      // For now, we'll need to reload participants from the current state
      if (state is ParticipantLoaded) {
        final currentState = state as ParticipantLoaded;
        final updatedParticipants = currentState.participants
            .map((p) => p.id == updatedParticipant.id ? updatedParticipant : p)
            .toList();

        final statistics = turnService.getTurnStatistics(updatedParticipants);
        emit(ParticipantLoaded(
          participants: updatedParticipants,
          statistics: statistics,
        ));
      }
    } catch (e) {
      emit(ParticipantError('Failed to update participant: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveParticipant(
    RemoveParticipant event,
    Emitter<ParticipantState> emit,
  ) async {
    try {
      emit(const ParticipantLoading());

      await participantRepository.removeParticipantFromGroup(
        event.groupId,
        event.participantId,
      );

      // Reload participants
      final result = await getParticipants(GetParticipantsParams(
        groupId: event.groupId,
      ));

      result.fold(
        (failure) => emit(ParticipantError(failure.toString())),
        (participants) {
          emit(ParticipantOperationSuccess(
            message: 'Participant removed successfully',
            participants: participants,
          ));
        },
      );
    } catch (e) {
      emit(ParticipantError('Failed to remove participant: ${e.toString()}'));
    }
  }

  Future<void> _onToggleParticipantStatus(
    ToggleParticipantStatus event,
    Emitter<ParticipantState> emit,
  ) async {
    try {
      // Don't emit loading state for quick toggle operations
      final updatedParticipant = await participantRepository
          .updateParticipantStatus(event.participantId, event.isActive);

      if (state is ParticipantLoaded) {
        final currentState = state as ParticipantLoaded;
        final updatedParticipants = currentState.participants
            .map((p) => p.id == updatedParticipant.id ? updatedParticipant : p)
            .toList();

        final statistics = turnService.getTurnStatistics(updatedParticipants);
        emit(ParticipantLoaded(
          participants: updatedParticipants,
          statistics: statistics,
        ));
      }
    } catch (e) {
      emit(ParticipantError(
          'Failed to update participant status: ${e.toString()}'));
    }
  }

  Future<void> _onResetTurnCounts(
    ResetTurnCounts event,
    Emitter<ParticipantState> emit,
  ) async {
    try {
      emit(const ParticipantLoading());

      await participantRepository.resetTurnCounts(event.groupId);

      // Reload participants
      final result = await getParticipants(GetParticipantsParams(
        groupId: event.groupId,
      ));

      result.fold(
        (failure) => emit(ParticipantError(failure.toString())),
        (participants) {
          emit(ParticipantOperationSuccess(
            message: 'Turn counts reset successfully',
            participants: participants,
          ));
        },
      );
    } catch (e) {
      emit(ParticipantError('Failed to reset turn counts: ${e.toString()}'));
    }
  }
}
