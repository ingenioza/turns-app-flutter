import 'package:flutter/material.dart';

import '../../../domain/entities/participant.dart';
import 'participant_item.dart';

/// Widget for displaying a list of participants
class ParticipantList extends StatelessWidget {
  final List<Participant> participants;
  final Function(Participant)? onParticipantTap;
  final Function(String participantId, bool isActive)? onToggleStatus;
  final Function(String participantId)? onRemoveParticipant;
  final bool showActions;
  final bool showOnlyActive;

  const ParticipantList({
    super.key,
    required this.participants,
    this.onParticipantTap,
    this.onToggleStatus,
    this.onRemoveParticipant,
    this.showActions = true,
    this.showOnlyActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final filteredParticipants = showOnlyActive
        ? participants.where((p) => p.isActive).toList()
        : participants;

    if (filteredParticipants.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              showOnlyActive 
                  ? 'No active participants'
                  : 'No participants yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              showOnlyActive
                  ? 'Activate some participants to get started'
                  : 'Add participants to get started',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredParticipants.length,
      itemBuilder: (context, index) {
        final participant = filteredParticipants[index];
        
        return ParticipantItem(
          participant: participant,
          showActions: showActions,
          onTap: onParticipantTap != null 
              ? () => onParticipantTap!(participant)
              : null,
          onToggleStatus: onToggleStatus != null
              ? () => onToggleStatus!(participant.id, !participant.isActive)
              : null,
          onRemove: onRemoveParticipant != null
              ? () => onRemoveParticipant!(participant.id)
              : null,
        );
      },
    );
  }
}

/// Summary widget showing participant statistics
class ParticipantSummary extends StatelessWidget {
  final List<Participant> participants;
  final Map<String, dynamic> statistics;

  const ParticipantSummary({
    super.key,
    required this.participants,
    required this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Group Summary',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total',
                    '${statistics['participantCount']}',
                    Icons.people,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Active',
                    '${statistics['activeParticipantCount']}',
                    Icons.person,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Turns',
                    '${statistics['totalTurns']}',
                    Icons.rotate_right,
                  ),
                ),
              ],
            ),
            if (statistics['turnVariance'] as int > 1) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning,
                      size: 16,
                      color: theme.colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Turn distribution is uneven. Consider using a fairness algorithm.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
