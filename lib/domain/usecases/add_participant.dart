import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/participant.dart';
import '../repositories/participant_repository.dart';

/// Use case for adding a participant to a group
class AddParticipant implements UseCase<Participant, AddParticipantParams> {
  final ParticipantRepository repository;

  AddParticipant(this.repository);

  @override
  Future<Either<Failure, Participant>> call(AddParticipantParams params) async {
    try {
      // Validate participant name
      if (params.participant.name.trim().isEmpty) {
        return const Left(ValidationFailure(
          message: 'Participant name cannot be empty',
        ));
      }

      // Check for duplicate names in the group
      final existingParticipants =
          await repository.getParticipantsByGroupId(params.groupId);

      final duplicateName = existingParticipants.any(
        (p) => p.name.toLowerCase() == params.participant.name.toLowerCase(),
      );

      if (duplicateName) {
        return const Left(ValidationFailure(
          message: 'Participant name already exists',
        ));
      }

      final participant =
          await repository.createParticipant(params.participant);
      return Right(participant);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

class AddParticipantParams {
  final String groupId;
  final Participant participant;

  AddParticipantParams({
    required this.groupId,
    required this.participant,
  });
}
