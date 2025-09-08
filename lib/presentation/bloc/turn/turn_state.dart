import 'package:equatable/equatable.dart';

import '../../../domain/algorithms/turn_algorithm.dart';
import '../../../domain/entities/participant.dart';
import '../../../domain/services/turn_service.dart';

/// States for turn execution
abstract class TurnState extends Equatable {
  const TurnState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class TurnInitial extends TurnState {
  const TurnInitial();
}

/// Loading turn execution
class TurnLoading extends TurnState {
  const TurnLoading();
}

/// Turn executed successfully
class TurnSuccess extends TurnState {
  final TurnResult result;
  final List<TurnAlgorithm> availableAlgorithms;
  final TurnAlgorithm selectedAlgorithm;

  const TurnSuccess({
    required this.result,
    required this.availableAlgorithms,
    required this.selectedAlgorithm,
  });

  @override
  List<Object?> get props => [result, availableAlgorithms, selectedAlgorithm];

  /// Helper getters
  Participant get selectedParticipant => result.selectedParticipant;
  DateTime get executedAt => result.executedAt;
  List<Participant> get allParticipants => result.allParticipants;
}

/// Algorithm selection state
class AlgorithmSelectionState extends TurnState {
  final List<TurnAlgorithm> availableAlgorithms;
  final TurnAlgorithm selectedAlgorithm;

  const AlgorithmSelectionState({
    required this.availableAlgorithms,
    required this.selectedAlgorithm,
  });

  @override
  List<Object?> get props => [availableAlgorithms, selectedAlgorithm];
}

/// Error state
class TurnError extends TurnState {
  final String message;

  const TurnError(this.message);

  @override
  List<Object?> get props => [message];
}
