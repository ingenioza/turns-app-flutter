import 'package:equatable/equatable.dart';

import '../entities/participant.dart';
import '../algorithms/turn_algorithm.dart';

/// Represents the result of a turn execution
class TurnResult extends Equatable {
  /// The selected participant
  final Participant selectedParticipant;

  /// Algorithm used for selection
  final TurnAlgorithm algorithm;

  /// Timestamp when turn was executed
  final DateTime executedAt;

  /// List of all participants at time of execution
  final List<Participant> allParticipants;

  /// Previous turn history context
  final List<String> turnHistory;

  const TurnResult({
    required this.selectedParticipant,
    required this.algorithm,
    required this.executedAt,
    required this.allParticipants,
    required this.turnHistory,
  });

  @override
  List<Object?> get props => [
        selectedParticipant,
        algorithm,
        executedAt,
        allParticipants,
        turnHistory,
      ];
}

/// Service for executing turns and managing turn logic
class TurnService {
  /// Executes a turn using the specified algorithm
  ///
  /// Returns a [TurnResult] with the selected participant and context
  /// Throws [ArgumentError] if no participants are available
  TurnResult executeTurn({
    required TurnAlgorithm algorithm,
    required List<Participant> participants,
    String? lastSelectedId,
    List<String> turnHistory = const [],
  }) {
    if (participants.isEmpty) {
      throw ArgumentError('Cannot execute turn: No participants provided');
    }

    final activeParticipants = participants.where((p) => p.isActive).toList();
    if (activeParticipants.isEmpty) {
      throw ArgumentError('Cannot execute turn: No active participants');
    }

    if (!algorithm.canApply(participants)) {
      throw ArgumentError(
          'Algorithm cannot be applied to current participants');
    }

    final selectedParticipant = algorithm.selectNext(
      participants,
      lastSelectedId: lastSelectedId,
      turnHistory: turnHistory,
    );

    return TurnResult(
      selectedParticipant: selectedParticipant,
      algorithm: algorithm,
      executedAt: DateTime.now(),
      allParticipants: List.unmodifiable(participants),
      turnHistory: List.unmodifiable(turnHistory),
    );
  }

  /// Updates participant turn counts after a successful turn
  List<Participant> updateTurnCounts(
    List<Participant> participants,
    String selectedParticipantId,
  ) {
    return participants.map((participant) {
      if (participant.id == selectedParticipantId) {
        return participant.incrementTurnCount();
      }
      return participant;
    }).toList();
  }

  /// Gets statistics about turn distribution
  Map<String, dynamic> getTurnStatistics(List<Participant> participants) {
    final totalTurns = participants.fold<int>(
      0,
      (sum, participant) => sum + participant.turnCount,
    );

    final activeTurns = participants
        .where((p) => p.isActive)
        .fold<int>(0, (sum, participant) => sum + participant.turnCount);

    final averageTurns =
        participants.isNotEmpty ? totalTurns / participants.length : 0.0;

    final maxTurns = participants.isNotEmpty
        ? participants.map((p) => p.turnCount).reduce((a, b) => a > b ? a : b)
        : 0;

    final minTurns = participants.isNotEmpty
        ? participants.map((p) => p.turnCount).reduce((a, b) => a < b ? a : b)
        : 0;

    return {
      'totalTurns': totalTurns,
      'activeTurns': activeTurns,
      'averageTurns': averageTurns,
      'maxTurns': maxTurns,
      'minTurns': minTurns,
      'participantCount': participants.length,
      'activeParticipantCount': participants.where((p) => p.isActive).length,
      'turnVariance': maxTurns - minTurns,
    };
  }

  /// Checks if turn distribution is fair (low variance)
  bool isDistributionFair(
    List<Participant> participants, {
    int maxVariance = 1,
  }) {
    if (participants.length <= 1) return true;

    final stats = getTurnStatistics(participants);
    return (stats['turnVariance'] as int) <= maxVariance;
  }
}
