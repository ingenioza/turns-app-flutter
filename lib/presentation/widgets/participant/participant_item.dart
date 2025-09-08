import 'package:flutter/material.dart';

import '../../../domain/entities/participant.dart';
import '../../../core/theme/app_colors.dart';

/// Widget for displaying a single participant item
class ParticipantItem extends StatelessWidget {
  final Participant participant;
  final VoidCallback? onTap;
  final VoidCallback? onToggleStatus;
  final VoidCallback? onRemove;
  final bool showActions;

  const ParticipantItem({
    super.key,
    required this.participant,
    this.onTap,
    this.onToggleStatus,
    this.onRemove,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(int.parse(
            participant.displayColor.replaceFirst('#', '0xFF'),
          )),
          child: Text(
            participant.name.isNotEmpty
                ? participant.name[0].toUpperCase()
                : '?',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          participant.name,
          style: TextStyle(
            color: participant.isActive
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurface.withValues(alpha: 0.5),
            decoration: participant.isActive
                ? TextDecoration.none
                : TextDecoration.lineThrough,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Turns: ${participant.turnCount}'),
            if (participant.weight != 1.0)
              Text('Weight: ${participant.weight.toStringAsFixed(1)}'),
          ],
        ),
        trailing: showActions
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: onToggleStatus,
                    icon: Icon(
                      participant.isActive
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: participant.isActive
                          ? AppColors.success
                          : AppColors.textSecondaryLight,
                    ),
                    tooltip: participant.isActive
                        ? 'Deactivate participant'
                        : 'Activate participant',
                  ),
                  IconButton(
                    onPressed: onRemove,
                    icon: const Icon(
                      Icons.delete,
                      color: AppColors.error,
                    ),
                    tooltip: 'Remove participant',
                  ),
                ],
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
