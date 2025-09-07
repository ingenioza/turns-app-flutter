import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/algorithms/fairness_turn_algorithm.dart';
import '../../../domain/algorithms/random_turn_algorithm.dart';
import '../../../domain/algorithms/round_robin_turn_algorithm.dart';
import '../../../domain/algorithms/turn_algorithm.dart';
import '../../../domain/algorithms/weighted_turn_algorithm.dart';
import '../../../domain/usecases/execute_turn.dart' as turn_usecase;
import 'turn_event.dart';
import 'turn_state.dart';

@injectable
class TurnBloc extends Bloc<TurnEvent, TurnState> {
  final turn_usecase.ExecuteTurn executeTurnUseCase;
  
  late final List<TurnAlgorithm> _availableAlgorithms;
  late TurnAlgorithm _selectedAlgorithm;

  TurnBloc({
    required this.executeTurnUseCase,
  }) : super(const TurnInitial()) {
    _initializeAlgorithms();
    
    on<LoadAlgorithms>(_onLoadAlgorithms);
    on<ChangeAlgorithm>(_onChangeAlgorithm);
    on<ExecuteTurn>(_onExecuteTurn);
    on<ResetTurn>(_onResetTurn);
  }

  void _initializeAlgorithms() {
    _availableAlgorithms = [
      RandomTurnAlgorithm(),
      RoundRobinTurnAlgorithm(),
      WeightedTurnAlgorithm(),
      FairnessTurnAlgorithm(),
    ];
    _selectedAlgorithm = _availableAlgorithms.first;
  }

  Future<void> _onLoadAlgorithms(
    LoadAlgorithms event,
    Emitter<TurnState> emit,
  ) async {
    emit(AlgorithmSelectionState(
      availableAlgorithms: _availableAlgorithms,
      selectedAlgorithm: _selectedAlgorithm,
    ));
  }

  Future<void> _onChangeAlgorithm(
    ChangeAlgorithm event,
    Emitter<TurnState> emit,
  ) async {
    _selectedAlgorithm = event.algorithm;
    
    emit(AlgorithmSelectionState(
      availableAlgorithms: _availableAlgorithms,
      selectedAlgorithm: _selectedAlgorithm,
    ));
  }

  Future<void> _onExecuteTurn(
    ExecuteTurn event,
    Emitter<TurnState> emit,
  ) async {
    emit(const TurnLoading());

    final result = await executeTurnUseCase(turn_usecase.ExecuteTurnParams(
      groupId: event.groupId,
      algorithm: event.algorithm,
      lastSelectedId: event.lastSelectedId,
      turnHistory: event.turnHistory,
    ));

    result.fold(
      (failure) => emit(TurnError(failure.toString())),
      (turnResult) => emit(TurnSuccess(
        result: turnResult,
        availableAlgorithms: _availableAlgorithms,
        selectedAlgorithm: event.algorithm,
      )),
    );
  }

  Future<void> _onResetTurn(
    ResetTurn event,
    Emitter<TurnState> emit,
  ) async {
    emit(AlgorithmSelectionState(
      availableAlgorithms: _availableAlgorithms,
      selectedAlgorithm: _selectedAlgorithm,
    ));
  }

  /// Helper methods
  TurnAlgorithm get currentAlgorithm => _selectedAlgorithm;
  List<TurnAlgorithm> get algorithms => _availableAlgorithms;
}
