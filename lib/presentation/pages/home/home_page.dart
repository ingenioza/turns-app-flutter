import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/algorithms/random_turn_algorithm.dart';
import '../../../domain/entities/participant.dart';
import '../../bloc/participant/participant_bloc.dart';
import '../../bloc/participant/participant_event.dart' as participant_events;
import '../../bloc/participant/participant_state.dart';
import '../../bloc/turn/turn_bloc.dart';
import '../../bloc/turn/turn_event.dart' as turn_events;
import '../../bloc/turn/turn_state.dart';
import '../../widgets/participant/participant_list.dart';
import '../../widgets/turn/turn_wheel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _nameController = TextEditingController();
  final _uuid = const Uuid();
  
  // Demo group ID - in a real app this would come from navigation/routing
  final String _demoGroupId = 'demo-group-123';

  @override
  void initState() {
    super.initState();
    // Load demo participants for the home screen
    _loadDemoParticipants();
  }

  void _loadDemoParticipants() {
    // Add some demo participants if none exist
    final demoParticipants = [
      Participant(
        id: _uuid.v4(),
        name: 'Alice',
        color: '#FF5722',
        createdAt: DateTime.now(),
      ),
      Participant(
        id: _uuid.v4(),
        name: 'Bob',
        color: '#2196F3',
        createdAt: DateTime.now(),
      ),
      Participant(
        id: _uuid.v4(),
        name: 'Charlie',
        color: '#4CAF50',
        createdAt: DateTime.now(),
      ),
      Participant(
        id: _uuid.v4(),
        name: 'Diana',
        color: '#9C27B0',
        createdAt: DateTime.now(),
      ),
    ];

    // Add each participant (this will check for duplicates in the bloc)
    for (final participant in demoParticipants) {
      context.read<ParticipantBloc>().add(
        participant_events.AddParticipant(
          groupId: _demoGroupId,
          participant: participant,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Turns Demo'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _showAddParticipantDialog(),
            icon: const Icon(Icons.person_add),
            tooltip: 'Add Participant',
          ),
        ],
      ),
      body: BlocListener<ParticipantBloc, ParticipantState>(
        listener: (context, state) {
          if (state is ParticipantError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is ParticipantOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
          }
        },
        child: Column(
          children: [
            // Turn wheel section
            Expanded(
              flex: 2,
              child: BlocBuilder<TurnBloc, TurnState>(
                builder: (context, turnState) {
                  return BlocBuilder<ParticipantBloc, ParticipantState>(
                    builder: (context, participantState) {
                      final participants = participantState is ParticipantLoaded
                          ? participantState.participants
                          : <Participant>[];

                      final selectedParticipant = turnState is TurnSuccess
                          ? turnState.selectedParticipant
                          : null;

                      final isSpinning = turnState is TurnLoading;

                      return Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TurnWheel(
                              participants: participants,
                              selectedParticipant: selectedParticipant,
                              isSpinning: isSpinning,
                              size: 280,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: participants.any((p) => p.isActive)
                                  ? () => _executeTurn(participants)
                                  : null,
                              icon: Icon(isSpinning 
                                  ? Icons.hourglass_empty 
                                  : Icons.play_arrow),
                              label: Text(isSpinning 
                                  ? 'Spinning...' 
                                  : 'Spin the Wheel!'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            
            // Participants section
            Expanded(
              flex: 3,
              child: BlocBuilder<ParticipantBloc, ParticipantState>(
                builder: (context, state) {
                  if (state is ParticipantLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is ParticipantLoaded) {
                    return Column(
                      children: [
                        ParticipantSummary(
                          participants: state.participants,
                          statistics: state.statistics,
                        ),
                        Expanded(
                          child: ParticipantList(
                            participants: state.participants,
                            onToggleStatus: (participantId, isActive) {
                              context.read<ParticipantBloc>().add(
                                participant_events.ToggleParticipantStatus(
                                  participantId: participantId,
                                  isActive: isActive,
                                ),
                              );
                            },
                            onRemoveParticipant: (participantId) {
                              context.read<ParticipantBloc>().add(
                                participant_events.RemoveParticipant(
                                  groupId: _demoGroupId,
                                  participantId: participantId,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }

                  return const Center(
                    child: Text('Welcome to Turns!'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddParticipantDialog(),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _executeTurn(List<Participant> participants) {
    context.read<TurnBloc>().add(
      turn_events.ExecuteTurn(
        groupId: _demoGroupId,
        algorithm: RandomTurnAlgorithm(),
      ),
    );
  }

  void _showAddParticipantDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Participant'),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.words,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              _nameController.clear();
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = _nameController.text.trim();
              if (name.isNotEmpty) {
                final participant = Participant(
                  id: _uuid.v4(),
                  name: name,
                  createdAt: DateTime.now(),
                );

                context.read<ParticipantBloc>().add(
                  participant_events.AddParticipant(
                    groupId: _demoGroupId,
                    participant: participant,
                  ),
                );

                _nameController.clear();
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
