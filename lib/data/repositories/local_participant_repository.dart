import '../../../domain/entities/participant.dart';
import '../../../domain/repositories/participant_repository.dart';

/// Local/mock implementation of ParticipantRepository for development and testing
class LocalParticipantRepository implements ParticipantRepository {
  // In-memory storage for demo purposes
  final Map<String, List<Participant>> _participantsByGroup = {};
  final Map<String, Participant> _participantsById = {};

  @override
  Future<List<Participant>> getParticipantsByGroupId(String groupId) async {
    return _participantsByGroup[groupId] ?? [];
  }

  @override
  Future<Participant?> getParticipantById(String participantId) async {
    return _participantsById[participantId];
  }

  @override
  Future<Participant> createParticipant(Participant participant) async {
    _participantsById[participant.id] = participant;
    return participant;
  }

  @override
  Future<Participant> updateParticipant(Participant participant) async {
    _participantsById[participant.id] = participant;

    // Update in group lists
    for (final groupParticipants in _participantsByGroup.values) {
      for (int i = 0; i < groupParticipants.length; i++) {
        if (groupParticipants[i].id == participant.id) {
          groupParticipants[i] = participant;
          break;
        }
      }
    }

    return participant;
  }

  @override
  Future<void> deleteParticipant(String participantId) async {
    _participantsById.remove(participantId);

    // Remove from all groups
    for (final groupParticipants in _participantsByGroup.values) {
      groupParticipants.removeWhere((p) => p.id == participantId);
    }
  }

  @override
  Future<List<Participant>> addParticipantsToGroup(
    String groupId,
    List<Participant> participants,
  ) async {
    final groupParticipants = _participantsByGroup[groupId] ?? [];

    for (final participant in participants) {
      // Check for duplicate names
      final duplicateName = groupParticipants.any(
        (p) => p.name.toLowerCase() == participant.name.toLowerCase(),
      );

      if (!duplicateName) {
        groupParticipants.add(participant);
        _participantsById[participant.id] = participant;
      }
    }

    _participantsByGroup[groupId] = groupParticipants;
    return groupParticipants;
  }

  @override
  Future<void> removeParticipantFromGroup(
    String groupId,
    String participantId,
  ) async {
    final groupParticipants = _participantsByGroup[groupId] ?? [];
    groupParticipants.removeWhere((p) => p.id == participantId);
    _participantsById.remove(participantId);
  }

  @override
  Future<Participant> updateTurnCount(
      String participantId, int newTurnCount) async {
    final participant = _participantsById[participantId];
    if (participant == null) {
      throw Exception('Participant not found');
    }

    final updatedParticipant = participant.copyWith(
      turnCount: newTurnCount,
      updatedAt: DateTime.now(),
    );

    return updateParticipant(updatedParticipant);
  }

  @override
  Future<void> resetTurnCounts(String groupId) async {
    final groupParticipants = _participantsByGroup[groupId] ?? [];

    for (int i = 0; i < groupParticipants.length; i++) {
      final participant = groupParticipants[i];
      final resetParticipant = participant.copyWith(
        turnCount: 0,
        updatedAt: DateTime.now(),
      );

      groupParticipants[i] = resetParticipant;
      _participantsById[participant.id] = resetParticipant;
    }
  }

  @override
  Future<Participant> updateParticipantStatus(
    String participantId,
    bool isActive,
  ) async {
    final participant = _participantsById[participantId];
    if (participant == null) {
      throw Exception('Participant not found');
    }

    final updatedParticipant = participant.copyWith(
      isActive: isActive,
      updatedAt: DateTime.now(),
    );

    return updateParticipant(updatedParticipant);
  }

  @override
  Future<List<Participant>> getActiveParticipants(String groupId) async {
    final allParticipants = await getParticipantsByGroupId(groupId);
    return allParticipants.where((p) => p.isActive).toList();
  }

  @override
  Future<List<Participant>> searchParticipants(
    String groupId,
    String query,
  ) async {
    final allParticipants = await getParticipantsByGroupId(groupId);
    final lowerQuery = query.toLowerCase();

    return allParticipants
        .where((p) => p.name.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// Helper method to add a participant to a specific group (for demo purposes)
  Future<void> addParticipantToGroup(
      String groupId, Participant participant) async {
    final groupParticipants = _participantsByGroup[groupId] ?? [];

    // Check for duplicate names
    final duplicateName = groupParticipants.any(
      (p) => p.name.toLowerCase() == participant.name.toLowerCase(),
    );

    if (!duplicateName) {
      groupParticipants.add(participant);
      _participantsByGroup[groupId] = groupParticipants;
      _participantsById[participant.id] = participant;
    }
  }
}
