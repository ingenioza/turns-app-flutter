import 'package:equatable/equatable.dart';

/// Represents a participant in a turns group
class Participant extends Equatable {
  /// Unique identifier for the participant
  final String id;

  /// Display name of the participant
  final String name;

  /// Optional avatar/profile image URL
  final String? avatarUrl;

  /// Optional custom color for UI representation
  final String? color;

  /// Weight for weighted turn algorithms (default: 1.0)
  final double weight;

  /// Whether this participant is currently active
  final bool isActive;

  /// Number of turns this participant has taken
  final int turnCount;

  /// Timestamp when participant was created
  final DateTime createdAt;

  /// Timestamp when participant was last updated
  final DateTime? updatedAt;

  const Participant({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.color,
    this.weight = 1.0,
    this.isActive = true,
    this.turnCount = 0,
    required this.createdAt,
    this.updatedAt,
  });

  /// Creates a copy of this participant with modified fields
  Participant copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    String? color,
    double? weight,
    bool? isActive,
    int? turnCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Participant(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      color: color ?? this.color,
      weight: weight ?? this.weight,
      isActive: isActive ?? this.isActive,
      turnCount: turnCount ?? this.turnCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Creates a new participant with incremented turn count
  Participant incrementTurnCount() {
    return copyWith(
      turnCount: turnCount + 1,
      updatedAt: DateTime.now(),
    );
  }

  /// Validates if participant name is valid
  bool get hasValidName => name.trim().isNotEmpty;

  /// Gets display color or default
  String get displayColor => color ?? '#2196F3';

  /// Gets turn percentage based on total turns in group
  double getTurnPercentage(int totalTurns) {
    if (totalTurns == 0) return 0.0;
    return (turnCount / totalTurns) * 100;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        avatarUrl,
        color,
        weight,
        isActive,
        turnCount,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'Participant(id: $id, name: $name, weight: $weight, '
        'isActive: $isActive, turnCount: $turnCount)';
  }
}
