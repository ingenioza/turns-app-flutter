import 'dart:math';

import '../entities/participant.dart';
import 'turn_algorithm.dart';

/// Weighted turn selection algorithm
/// Selects participants based on their assigned weights
/// Higher weight = higher probability of being selected
class WeightedTurnAlgorithm extends TurnAlgorithm {
  final Random _random = Random();

  @override
  String get name => 'Weighted';

  @override
  String get description => 
      'Selects participants based on their weights. Higher weight = higher chance.';

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
    
    // Calculate total weight
    final totalWeight = activeParticipants
        .map((p) => p.weight)
        .reduce((a, b) => a + b);
    
    if (totalWeight <= 0) {
      throw ArgumentError('Total weight must be greater than 0');
    }
    
    // Generate random number between 0 and total weight
    final randomWeight = _random.nextDouble() * totalWeight;
    
    // Find participant based on weighted selection
    double currentWeight = 0;
    for (final participant in activeParticipants) {
      currentWeight += participant.weight;
      if (randomWeight <= currentWeight) {
        return participant;
      }
    }
    
    // Fallback (should not reach here)
    return activeParticipants.last;
  }

  @override
  bool canApply(List<Participant> participants) {
    final activeParticipants = getActiveParticipants(participants);
    return activeParticipants.isNotEmpty && 
           activeParticipants.any((p) => p.weight > 0);
  }
}
