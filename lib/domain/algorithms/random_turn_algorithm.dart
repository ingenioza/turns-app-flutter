import 'dart:math';

import '../entities/participant.dart';
import 'turn_algorithm.dart';

/// Random turn selection algorithm
/// Selects participants randomly with equal probability
class RandomTurnAlgorithm extends TurnAlgorithm {
  final Random _random = Random();

  @override
  String get name => 'Random';

  @override
  String get description =>
      'Selects participants randomly. Everyone has an equal chance.';

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
    final randomIndex = _random.nextInt(activeParticipants.length);

    return activeParticipants[randomIndex];
  }
}
