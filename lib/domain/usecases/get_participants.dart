import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/participant.dart';
import '../repositories/participant_repository.dart';

/// Use case for getting participants from a group
class GetParticipants
    implements UseCase<List<Participant>, GetParticipantsParams> {
  final ParticipantRepository repository;

  GetParticipants(this.repository);

  @override
  Future<Either<Failure, List<Participant>>> call(
      GetParticipantsParams params) async {
    try {
      final participants = params.activeOnly
          ? await repository.getActiveParticipants(params.groupId)
          : await repository.getParticipantsByGroupId(params.groupId);

      return Right(participants);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

class GetParticipantsParams {
  final String groupId;
  final bool activeOnly;

  GetParticipantsParams({
    required this.groupId,
    this.activeOnly = false,
  });
}
