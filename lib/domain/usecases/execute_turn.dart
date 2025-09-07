import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../algorithms/turn_algorithm.dart';
import '../repositories/participant_repository.dart';
import '../services/turn_service.dart';

/// Use case for executing a turn and selecting the next participant
class ExecuteTurn implements UseCase<TurnResult, ExecuteTurnParams> {
  final TurnService turnService;
  final ParticipantRepository participantRepository;

  ExecuteTurn({
    required this.turnService,
    required this.participantRepository,
  });

  @override
  Future<Either<Failure, TurnResult>> call(ExecuteTurnParams params) async {
    try {
      // Get current participants for the group
      final participants =
          await participantRepository.getParticipantsByGroupId(params.groupId);

      if (participants.isEmpty) {
        return const Left(ValidationFailure(
          message: 'No participants found in group',
        ));
      }

      final activeParticipants = participants.where((p) => p.isActive).toList();
      if (activeParticipants.isEmpty) {
        return const Left(ValidationFailure(
          message: 'No active participants available',
        ));
      }

      // Execute the turn
      final result = turnService.executeTurn(
        algorithm: params.algorithm,
        participants: participants,
        lastSelectedId: params.lastSelectedId,
        turnHistory: params.turnHistory,
      );

      // Update turn counts
      turnService.updateTurnCounts(
        participants,
        result.selectedParticipant.id,
      );

      // Save updated turn count
      await participantRepository.updateTurnCount(
        result.selectedParticipant.id,
        result.selectedParticipant.turnCount + 1,
      );

      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

class ExecuteTurnParams {
  final String groupId;
  final TurnAlgorithm algorithm;
  final String? lastSelectedId;
  final List<String> turnHistory;

  ExecuteTurnParams({
    required this.groupId,
    required this.algorithm,
    this.lastSelectedId,
    this.turnHistory = const [],
  });
}
