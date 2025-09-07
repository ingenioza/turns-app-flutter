import 'package:equatable/equatable.dart';

import '../../../domain/algorithms/turn_algorithm.dart';

/// Events for turn execution
abstract class TurnEvent extends Equatable {
  const TurnEvent();

  @override
  List<Object?> get props => [];
}

/// Execute a turn for a group
class ExecuteTurn extends TurnEvent {
  final String groupId;
  final TurnAlgorithm algorithm;
  final String? lastSelectedId;
  final List<String> turnHistory;

  const ExecuteTurn({
    required this.groupId,
    required this.algorithm,
    this.lastSelectedId,
    this.turnHistory = const [],
  });

  @override
  List<Object?> get props => [groupId, algorithm, lastSelectedId, turnHistory];
}

/// Reset turn state
class ResetTurn extends TurnEvent {
  const ResetTurn();
}

/// Load algorithm options
class LoadAlgorithms extends TurnEvent {
  const LoadAlgorithms();
}

/// Change selected algorithm
class ChangeAlgorithm extends TurnEvent {
  final TurnAlgorithm algorithm;

  const ChangeAlgorithm(this.algorithm);

  @override
  List<Object?> get props => [algorithm];
}
