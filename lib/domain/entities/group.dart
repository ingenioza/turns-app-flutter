import 'package:equatable/equatable.dart';

class Group extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String ownerId;
  final List<String> memberIds;
  final String turnAlgorithm;
  final Map<String, dynamic> settings;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Group({
    required this.id,
    required this.name,
    this.description,
    required this.ownerId,
    required this.memberIds,
    required this.turnAlgorithm,
    required this.settings,
    required this.createdAt,
    this.updatedAt,
  });

  Group copyWith({
    String? id,
    String? name,
    String? description,
    String? ownerId,
    List<String>? memberIds,
    String? turnAlgorithm,
    Map<String, dynamic>? settings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
      memberIds: memberIds ?? this.memberIds,
      turnAlgorithm: turnAlgorithm ?? this.turnAlgorithm,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isEmpty => memberIds.isEmpty;
  int get memberCount => memberIds.length;
  bool isOwner(String userId) => ownerId == userId;
  bool isMember(String userId) => memberIds.contains(userId);

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        ownerId,
        memberIds,
        turnAlgorithm,
        settings,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'Group(id: $id, name: $name, description: $description, ownerId: $ownerId, memberIds: $memberIds, turnAlgorithm: $turnAlgorithm, settings: $settings, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
