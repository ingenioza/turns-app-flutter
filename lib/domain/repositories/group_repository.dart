import '../entities/group.dart';

/// Repository interface for group data operations
abstract class GroupRepository {
  /// Gets all groups for the current user
  Future<List<Group>> getUserGroups();

  /// Gets a single group by ID
  Future<Group?> getGroupById(String groupId);

  /// Creates a new group
  Future<Group> createGroup(Group group);

  /// Updates an existing group
  Future<Group> updateGroup(Group group);

  /// Deletes a group
  Future<void> deleteGroup(String groupId);

  /// Gets recent groups (by last updated)
  Future<List<Group>> getRecentGroups({int limit = 10});

  /// Searches groups by name
  Future<List<Group>> searchGroups(String query);

  /// Creates an anonymous/temporary group
  Future<Group> createAnonymousGroup(Group group);

  /// Gets groups shared with the user
  Future<List<Group>> getSharedGroups();

  /// Shares a group with other users
  Future<void> shareGroup(String groupId, List<String> userIds);

  /// Joins a group using a share code
  Future<Group> joinGroupByCode(String shareCode);

  /// Generates a share code for a group
  Future<String> generateShareCode(String groupId);

  /// Updates group settings
  Future<Group> updateGroupSettings(
    String groupId,
    Map<String, dynamic> settings,
  );

  /// Updates group's last used timestamp
  Future<void> updateLastUsed(String groupId);

  /// Gets group statistics (turn counts, usage, etc.)
  Future<Map<String, dynamic>> getGroupStatistics(String groupId);
}
