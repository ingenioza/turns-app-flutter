import '../entities/participant.dart';
import 'turn_algorithm.dart';

/// Fairness-based turn selection algorithm
/// Prioritizes participants who have had fewer turns
class FairnessTurnAlgorithm extends TurnAlgorithm {
  @override
  String get name => 'Fairness';

  @override
  String get description =>
      'Prioritizes participants who have had fewer turns to ensure fairness.';

  @override
  Participant selectNext(
    List<Participant> participants, {
    String? lastSelectedId,
    List<String> turnHistory = const [],
  }) {
    if (!canApply(participants)) {
      throw ArgumentError('No active participants available');
    }

    final activeParticipants = getActiveParticipants(participants);

    // Find the minimum turn count among active participants
    final minTurnCount = activeParticipants
        .map((p) => p.turnCount)
        .reduce((a, b) => a < b ? a : b);

    // Get all participants with the minimum turn count
    final participantsWithMinTurns =
        activeParticipants.where((p) => p.turnCount == minTurnCount).toList();

    // If there's only one participant with minimum turns, select them
    if (participantsWithMinTurns.length == 1) {
      return participantsWithMinTurns.first;
    }

    // If multiple participants have the same minimum turns,
    // avoid selecting the last selected participant if possible
    if (lastSelectedId != null && participantsWithMinTurns.length > 1) {
      final withoutLastSelected = participantsWithMinTurns
          .where((p) => p.id != lastSelectedId)
          .toList();

      if (withoutLastSelected.isNotEmpty) {
        // Return first participant who wasn't last selected
        return withoutLastSelected.first;
      }
    }

    // Fallback: return first participant with minimum turns
    return participantsWithMinTurns.first;
  }
}
