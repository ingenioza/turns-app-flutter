import 'package:equatable/equatable.dart';

enum TurnStatus { pending, active, completed, skipped }

class Turn extends Equatable {
  final String id;
  final String groupId;
  final String userId;
  final int sequence;
  final TurnStatus status;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Turn({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.sequence,
    required this.status,
    this.startedAt,
    this.completedAt,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  Turn copyWith({
    String? id,
    String? groupId,
    String? userId,
    int? sequence,
    TurnStatus? status,
    DateTime? startedAt,
    DateTime? completedAt,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Turn(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      userId: userId ?? this.userId,
      sequence: sequence ?? this.sequence,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isActive => status == TurnStatus.active;
  bool get isCompleted => status == TurnStatus.completed;
  bool get isPending => status == TurnStatus.pending;
  bool get isSkipped => status == TurnStatus.skipped;

  Duration? get duration {
    if (startedAt != null && completedAt != null) {
      return completedAt!.difference(startedAt!);
    }
    return null;
  }

  @override
  List<Object?> get props => [
        id,
        groupId,
        userId,
        sequence,
        status,
        startedAt,
        completedAt,
        notes,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'Turn(id: $id, groupId: $groupId, userId: $userId, sequence: $sequence, status: $status, startedAt: $startedAt, completedAt: $completedAt, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
