import '../entities/participant.dart';

/// Repository interface for participant data operations
abstract class ParticipantRepository {
  /// Gets all participants for a specific group
  Future<List<Participant>> getParticipantsByGroupId(String groupId);
  
  /// Gets a single participant by ID
  Future<Participant?> getParticipantById(String participantId);
  
  /// Creates a new participant
  Future<Participant> createParticipant(Participant participant);
  
  /// Updates an existing participant
  Future<Participant> updateParticipant(Participant participant);
  
  /// Deletes a participant
  Future<void> deleteParticipant(String participantId);
  
  /// Adds multiple participants to a group
  Future<List<Participant>> addParticipantsToGroup(
    String groupId, 
    List<Participant> participants,
  );
  
  /// Removes a participant from a group
  Future<void> removeParticipantFromGroup(
    String groupId, 
    String participantId,
  );
  
  /// Updates participant turn count
  Future<Participant> updateTurnCount(
    String participantId, 
    int newTurnCount,
  );
  
  /// Resets turn counts for all participants in a group
  Future<void> resetTurnCounts(String groupId);
  
  /// Activates/deactivates a participant
  Future<Participant> updateParticipantStatus(
    String participantId, 
    bool isActive,
  );
  
  /// Gets active participants only for a group
  Future<List<Participant>> getActiveParticipants(String groupId);
  
  /// Searches participants by name within a group
  Future<List<Participant>> searchParticipants(
    String groupId, 
    String query,
  );
}
