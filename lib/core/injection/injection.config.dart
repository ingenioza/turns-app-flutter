// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../domain/repositories/participant_repository.dart' as _i558;
import '../../domain/services/turn_service.dart' as _i698;
import '../../domain/usecases/add_participant.dart' as _i271;
import '../../domain/usecases/execute_turn.dart' as _i384;
import '../../domain/usecases/get_participants.dart' as _i1044;
import '../../presentation/bloc/participant/participant_bloc.dart' as _i561;
import '../../presentation/bloc/turn/turn_bloc.dart' as _i127;
import '../network/network_service.dart' as _i1025;
import '../storage/storage_service.dart' as _i865;
import 'network_module.dart' as _i567;
import 'repository_module.dart' as _i130;
import 'storage_module.dart' as _i371;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final storageModule = _$StorageModule();
    final networkModule = _$NetworkModule();
    final repositoryModule = _$RepositoryModule();
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => storageModule.sharedPreferences,
      preResolve: true,
    );
    gh.singleton<_i361.Dio>(() => networkModule.dio);
    gh.lazySingleton<_i558.ParticipantRepository>(
        () => repositoryModule.participantRepository);
    gh.lazySingleton<_i698.TurnService>(() => repositoryModule.turnService);
    gh.singleton<_i865.StorageService>(
        () => _i865.StorageService(gh<_i460.SharedPreferences>()));
    gh.singleton<_i1025.NetworkService>(
        () => _i1025.NetworkService(gh<_i361.Dio>()));
    gh.factory<_i1044.GetParticipants>(
        () => _i1044.GetParticipants(gh<_i558.ParticipantRepository>()));
    gh.factory<_i271.AddParticipant>(
        () => _i271.AddParticipant(gh<_i558.ParticipantRepository>()));
    gh.factory<_i384.ExecuteTurn>(() => _i384.ExecuteTurn(
          turnService: gh<_i698.TurnService>(),
          participantRepository: gh<_i558.ParticipantRepository>(),
        ));
    gh.factory<_i561.ParticipantBloc>(() => _i561.ParticipantBloc(
          getParticipants: gh<_i1044.GetParticipants>(),
          addParticipant: gh<_i271.AddParticipant>(),
          participantRepository: gh<_i558.ParticipantRepository>(),
          turnService: gh<_i698.TurnService>(),
        ));
    gh.factory<_i127.TurnBloc>(
        () => _i127.TurnBloc(executeTurnUseCase: gh<_i384.ExecuteTurn>()));
    return this;
  }
}

class _$StorageModule extends _i371.StorageModule {}

class _$NetworkModule extends _i567.NetworkModule {}

class _$RepositoryModule extends _i130.RepositoryModule {}
