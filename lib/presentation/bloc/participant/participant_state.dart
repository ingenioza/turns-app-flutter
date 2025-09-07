import 'package:equatable/equatable.dart';

import '../../../domain/entities/participant.dart';

/// States for participant management
abstract class ParticipantState extends Equatable {
  const ParticipantState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ParticipantInitial extends ParticipantState {
  const ParticipantInitial();
}

/// Loading state
class ParticipantLoading extends ParticipantState {
  const ParticipantLoading();
}

/// Participants loaded successfully
class ParticipantLoaded extends ParticipantState {
  final List<Participant> participants;
  final Map<String, dynamic> statistics;

  const ParticipantLoaded({
    required this.participants,
    required this.statistics,
  });

  @override
  List<Object?> get props => [participants, statistics];

  /// Helper getters
  List<Participant> get activeParticipants =>
      participants.where((p) => p.isActive).toList();

  int get totalParticipants => participants.length;
  int get activeCount => activeParticipants.length;
  bool get hasParticipants => participants.isNotEmpty;
  bool get hasActiveParticipants => activeParticipants.isNotEmpty;
}

/// Error state
class ParticipantError extends ParticipantState {
  final String message;

  const ParticipantError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Participant operation successful
class ParticipantOperationSuccess extends ParticipantState {
  final String message;
  final List<Participant> participants;

  const ParticipantOperationSuccess({
    required this.message,
    required this.participants,
  });

  @override
  List<Object?> get props => [message, participants];
}
