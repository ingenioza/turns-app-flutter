import '../entities/participant.dart';

/// Abstract base class for turn selection algorithms
abstract class TurnAlgorithm {
  /// Algorithm name for display purposes
  String get name;
  
  /// Algorithm description for user understanding
  String get description;
  
  /// Selects the next participant based on the algorithm logic
  /// 
  /// [participants] - List of active participants
  /// [lastSelectedId] - ID of the last selected participant (if any)
  /// [turnHistory] - List of previous turn selections for context
  Participant selectNext(
    List<Participant> participants, {
    String? lastSelectedId,
    List<String> turnHistory = const [],
  });
  
  /// Validates if the algorithm can be applied to the given participants
  bool canApply(List<Participant> participants) {
    return participants.isNotEmpty && 
           participants.any((p) => p.isActive);
  }
  
  /// Gets list of active participants only
  List<Participant> getActiveParticipants(List<Participant> participants) {
    return participants.where((p) => p.isActive).toList();
  }
}
