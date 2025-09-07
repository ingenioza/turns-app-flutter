import '../entities/participant.dart';
import 'turn_algorithm.dart';

/// Round-robin turn selection algorithm
/// Cycles through participants in order, ensuring fair rotation
class RoundRobinTurnAlgorithm extends TurnAlgorithm {
  @override
  String get name => 'Round Robin';

  @override
  String get description => 
      'Cycles through participants in order. Everyone gets equal turns.';

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
    
    // If no previous selection or last selected is not in active list,
    // start from the beginning
    if (lastSelectedId == null) {
      return activeParticipants.first;
    }
    
    final lastIndex = activeParticipants
        .indexWhere((p) => p.id == lastSelectedId);
    
    if (lastIndex == -1) {
      // Last selected participant is no longer active, start from beginning
      return activeParticipants.first;
    }
    
    // Get next participant in the cycle
    final nextIndex = (lastIndex + 1) % activeParticipants.length;
    return activeParticipants[nextIndex];
  }
}
