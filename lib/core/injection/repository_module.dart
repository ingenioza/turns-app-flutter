import 'package:injectable/injectable.dart';

import '../../data/repositories/local_participant_repository.dart';
import '../../domain/repositories/participant_repository.dart';
import '../../domain/services/turn_service.dart';

/// Module for registering repositories and services
@module
abstract class RepositoryModule {
  @lazySingleton
  ParticipantRepository get participantRepository =>
      LocalParticipantRepository();

  @lazySingleton
  TurnService get turnService => TurnService();
}
