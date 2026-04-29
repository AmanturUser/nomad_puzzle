// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:image_picker/image_picker.dart' as _i183;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/ai_chat/data/datasources/chat_remote_datasource.dart'
    as _i696;
import '../../features/ai_chat/data/datasources/voice_remote_datasource.dart'
    as _i14;
import '../../features/ai_chat/data/repositories/chat_repository_impl.dart'
    as _i203;
import '../../features/ai_chat/data/repositories/voice_repository_impl.dart'
    as _i816;
import '../../features/ai_chat/domain/repositories/chat_repository.dart'
    as _i203;
import '../../features/ai_chat/domain/repositories/voice_repository.dart'
    as _i372;
import '../../features/ai_chat/domain/usecases/chat_usecases.dart' as _i51;
import '../../features/ai_chat/domain/usecases/voice_usecases.dart' as _i257;
import '../../features/ai_chat/presentation/bloc/chat_bloc.dart' as _i486;
import '../../features/ai_chat/presentation/bloc/chat_sessions_bloc.dart'
    as _i251;
import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/auth_usecases.dart' as _i46;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/camera/data/datasources/camera_datasource.dart' as _i261;
import '../../features/camera/data/repositories/camera_repository_impl.dart'
    as _i145;
import '../../features/camera/domain/repositories/camera_repository.dart'
    as _i491;
import '../../features/camera/domain/usecases/take_photo.dart' as _i932;
import '../../features/camera/presentation/bloc/camera_bloc.dart' as _i702;
import '../../features/challenges/data/datasources/challenges_fake_datasource.dart'
    as _i678;
import '../../features/challenges/data/datasources/challenges_remote_datasource.dart'
    as _i721;
import '../../features/challenges/data/repositories/challenges_repository_impl.dart'
    as _i331;
import '../../features/challenges/domain/repositories/challenges_repository.dart'
    as _i540;
import '../../features/challenges/domain/usecases/get_challenges.dart' as _i432;
import '../../features/challenges/presentation/bloc/challenge_details_bloc.dart'
    as _i407;
import '../../features/challenges/presentation/bloc/challenges_bloc.dart'
    as _i884;
import '../../features/map/presentation/bloc/map_bloc.dart' as _i437;
import '../../features/profile/data/datasources/profile_remote_datasource.dart'
    as _i327;
import '../../features/profile/data/repositories/profile_repository_impl.dart'
    as _i334;
import '../../features/profile/domain/repositories/profile_repository.dart'
    as _i894;
import '../../features/profile/domain/usecases/profile_usecases.dart' as _i591;
import '../../features/profile/presentation/bloc/profile_bloc.dart' as _i469;
import '../../features/submissions/data/repositories/submissions_stream_repository_impl.dart'
    as _i109;
import '../../features/submissions/domain/repositories/submissions_stream_repository.dart'
    as _i1005;
import '../../features/tours/data/datasources/tours_remote_datasource.dart'
    as _i297;
import '../../features/tours/data/repositories/tours_repository_impl.dart'
    as _i764;
import '../../features/tours/domain/repositories/tours_repository.dart'
    as _i922;
import '../../features/tours/domain/usecases/tours_usecases.dart' as _i415;
import '../../features/tours/presentation/bloc/tour_details_bloc.dart' as _i192;
import '../../features/tours/presentation/bloc/tours_bloc.dart' as _i875;
import '../auth/auth_token_storage.dart' as _i149;
import '../network/sse_client.dart' as _i901;
import 'register_module.dart' as _i291;

const String _dev = 'dev';
const String _prod = 'prod';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs(),
      preResolve: true,
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage(),
    );
    gh.lazySingleton<_i183.ImagePicker>(() => registerModule.imagePicker());
    gh.lazySingleton<_i149.AuthTokenStorage>(
      () => _i149.AuthTokenStorage(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i721.ChallengesRemoteDataSource>(
      () => _i678.ChallengesFakeDataSource(),
      registerFor: {_dev},
    );
    gh.lazySingleton<_i361.Dio>(
      () => registerModule.dio(gh<_i149.AuthTokenStorage>()),
    );
    gh.lazySingleton<_i901.SseClient>(
      () => registerModule.sseClient(gh<_i149.AuthTokenStorage>()),
    );
    gh.lazySingleton<_i721.ChallengesRemoteDataSource>(
      () => _i721.ChallengesRemoteDataSourceImpl(gh<_i361.Dio>()),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i261.CameraDataSource>(
      () => _i261.CameraDataSourceImpl(gh<_i183.ImagePicker>()),
    );
    gh.lazySingleton<_i297.ToursRemoteDataSource>(
      () => _i297.ToursRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i161.AuthRemoteDataSource>(
      () => _i161.AuthRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i540.ChallengesRepository>(
      () => _i331.ChallengesRepositoryImpl(
        gh<_i721.ChallengesRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(
        gh<_i161.AuthRemoteDataSource>(),
        gh<_i149.AuthTokenStorage>(),
      ),
    );
    gh.factory<_i432.GetChallenges>(
      () => _i432.GetChallenges(gh<_i540.ChallengesRepository>()),
    );
    gh.factory<_i432.GetChallenge>(
      () => _i432.GetChallenge(gh<_i540.ChallengesRepository>()),
    );
    gh.factory<_i432.CompleteChallenge>(
      () => _i432.CompleteChallenge(gh<_i540.ChallengesRepository>()),
    );
    gh.lazySingleton<_i327.ProfileRemoteDataSource>(
      () => _i327.ProfileRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i491.CameraRepository>(
      () => _i145.CameraRepositoryImpl(gh<_i261.CameraDataSource>()),
    );
    gh.lazySingleton<_i922.ToursRepository>(
      () => _i764.ToursRepositoryImpl(gh<_i297.ToursRemoteDataSource>()),
    );
    gh.lazySingleton<_i696.ChatRemoteDataSource>(
      () => _i696.ChatRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i14.VoiceRemoteDataSource>(
      () => _i14.VoiceRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i1005.SubmissionsStreamRepository>(
      () => _i109.SubmissionsStreamRepositoryImpl(gh<_i901.SseClient>()),
    );
    gh.lazySingleton<_i894.ProfileRepository>(
      () => _i334.ProfileRepositoryImpl(gh<_i327.ProfileRemoteDataSource>()),
    );
    gh.factory<_i932.TakePhoto>(
      () => _i932.TakePhoto(gh<_i491.CameraRepository>()),
    );
    gh.factory<_i932.PickFromGallery>(
      () => _i932.PickFromGallery(gh<_i491.CameraRepository>()),
    );
    gh.factory<_i932.RequestCameraPermission>(
      () => _i932.RequestCameraPermission(gh<_i491.CameraRepository>()),
    );
    gh.lazySingleton<_i372.VoiceRepository>(
      () => _i816.VoiceRepositoryImpl(gh<_i14.VoiceRemoteDataSource>()),
    );
    gh.factory<_i46.Login>(() => _i46.Login(gh<_i787.AuthRepository>()));
    gh.factory<_i46.Register>(() => _i46.Register(gh<_i787.AuthRepository>()));
    gh.factory<_i46.SignOutUser>(
      () => _i46.SignOutUser(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i415.GetTours>(
      () => _i415.GetTours(gh<_i922.ToursRepository>()),
    );
    gh.factory<_i415.GetTour>(() => _i415.GetTour(gh<_i922.ToursRepository>()));
    gh.factory<_i415.GetTourDepartures>(
      () => _i415.GetTourDepartures(gh<_i922.ToursRepository>()),
    );
    gh.factory<_i702.CameraBloc>(
      () => _i702.CameraBloc(
        gh<_i932.RequestCameraPermission>(),
        gh<_i932.TakePhoto>(),
        gh<_i932.PickFromGallery>(),
      ),
    );
    gh.singleton<_i797.AuthBloc>(
      () => _i797.AuthBloc(
        gh<_i46.Login>(),
        gh<_i46.Register>(),
        gh<_i46.SignOutUser>(),
        gh<_i787.AuthRepository>(),
      ),
    );
    gh.factory<_i257.TranscribeAudio>(
      () => _i257.TranscribeAudio(gh<_i372.VoiceRepository>()),
    );
    gh.factory<_i257.SynthesizeSpeech>(
      () => _i257.SynthesizeSpeech(gh<_i372.VoiceRepository>()),
    );
    gh.factory<_i884.ChallengesBloc>(
      () => _i884.ChallengesBloc(
        gh<_i432.GetChallenges>(),
        gh<_i432.CompleteChallenge>(),
      ),
    );
    gh.factory<_i407.ChallengeDetailsBloc>(
      () => _i407.ChallengeDetailsBloc(
        gh<_i432.GetChallenge>(),
        gh<_i432.CompleteChallenge>(),
      ),
    );
    gh.factory<_i875.ToursBloc>(() => _i875.ToursBloc(gh<_i415.GetTours>()));
    gh.factory<_i591.GetProfile>(
      () => _i591.GetProfile(gh<_i894.ProfileRepository>()),
    );
    gh.factory<_i591.UpdateProfile>(
      () => _i591.UpdateProfile(gh<_i894.ProfileRepository>()),
    );
    gh.factory<_i591.UploadAvatar>(
      () => _i591.UploadAvatar(gh<_i894.ProfileRepository>()),
    );
    gh.factory<_i591.GetProfileStats>(
      () => _i591.GetProfileStats(gh<_i894.ProfileRepository>()),
    );
    gh.factory<_i591.SignOut>(
      () => _i591.SignOut(gh<_i894.ProfileRepository>()),
    );
    gh.lazySingleton<_i203.ChatRepository>(
      () => _i203.ChatRepositoryImpl(gh<_i696.ChatRemoteDataSource>()),
    );
    gh.factory<_i192.TourDetailsBloc>(
      () => _i192.TourDetailsBloc(
        gh<_i415.GetTour>(),
        gh<_i415.GetTourDepartures>(),
      ),
    );
    gh.factory<_i437.MapBloc>(
      () => _i437.MapBloc(
        gh<_i432.GetChallenges>(),
        gh<_i432.CompleteChallenge>(),
        gh<_i1005.SubmissionsStreamRepository>(),
      ),
    );
    gh.factory<_i469.ProfileBloc>(
      () => _i469.ProfileBloc(
        gh<_i591.GetProfile>(),
        gh<_i591.UpdateProfile>(),
        gh<_i591.UploadAvatar>(),
        gh<_i591.GetProfileStats>(),
        gh<_i591.SignOut>(),
      ),
    );
    gh.factory<_i51.ListChatSessions>(
      () => _i51.ListChatSessions(gh<_i203.ChatRepository>()),
    );
    gh.factory<_i51.CreateChatSession>(
      () => _i51.CreateChatSession(gh<_i203.ChatRepository>()),
    );
    gh.factory<_i51.GetChatSession>(
      () => _i51.GetChatSession(gh<_i203.ChatRepository>()),
    );
    gh.factory<_i51.DeleteChatSession>(
      () => _i51.DeleteChatSession(gh<_i203.ChatRepository>()),
    );
    gh.factory<_i51.ListChatMessages>(
      () => _i51.ListChatMessages(gh<_i203.ChatRepository>()),
    );
    gh.factory<_i51.SendChatMessage>(
      () => _i51.SendChatMessage(gh<_i203.ChatRepository>()),
    );
    gh.factory<_i486.ChatBloc>(
      () => _i486.ChatBloc(
        gh<_i51.ListChatMessages>(),
        gh<_i51.SendChatMessage>(),
        gh<_i257.TranscribeAudio>(),
        gh<_i257.SynthesizeSpeech>(),
      ),
    );
    gh.factory<_i251.ChatSessionsBloc>(
      () => _i251.ChatSessionsBloc(
        gh<_i51.ListChatSessions>(),
        gh<_i51.CreateChatSession>(),
        gh<_i51.DeleteChatSession>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
