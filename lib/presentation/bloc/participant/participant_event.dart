import 'package:equatable/equatable.dart';

import '../../../domain/entities/participant.dart';

/// Events for participant management
abstract class ParticipantEvent extends Equatable {
  const ParticipantEvent();

  @override
  List<Object?> get props => [];
}

/// Load participants for a group
class LoadParticipants extends ParticipantEvent {
  final String groupId;
  final bool activeOnly;

  const LoadParticipants({
    required this.groupId,
    this.activeOnly = false,
  });

  @override
  List<Object?> get props => [groupId, activeOnly];
}

/// Add a new participant
class AddParticipant extends ParticipantEvent {
  final String groupId;
  final Participant participant;

  const AddParticipant({
    required this.groupId,
    required this.participant,
  });

  @override
  List<Object?> get props => [groupId, participant];
}

/// Update participant
class UpdateParticipant extends ParticipantEvent {
  final Participant participant;

  const UpdateParticipant(this.participant);

  @override
  List<Object?> get props => [participant];
}

/// Remove participant
class RemoveParticipant extends ParticipantEvent {
  final String groupId;
  final String participantId;

  const RemoveParticipant({
    required this.groupId,
    required this.participantId,
  });

  @override
  List<Object?> get props => [groupId, participantId];
}

/// Toggle participant active status
class ToggleParticipantStatus extends ParticipantEvent {
  final String participantId;
  final bool isActive;

  const ToggleParticipantStatus({
    required this.participantId,
    required this.isActive,
  });

  @override
  List<Object?> get props => [participantId, isActive];
}

/// Reset turn counts for all participants
class ResetTurnCounts extends ParticipantEvent {
  final String groupId;

  const ResetTurnCounts(this.groupId);

  @override
  List<Object?> get props => [groupId];
}
