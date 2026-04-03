import 'package:get_it/get_it.dart';
import 'package:hyprion/data/dependencies/dependencies.dart';
import 'package:hyprion/data/dependencies/hyprland_dependencies.dart';
import 'package:hyprion/data/dependencies/testing/dependencies_mock.dart';
import 'package:hyprion/data/storage/profile_storage.dart';
import 'package:hyprion/data/storage/profile_storage_impl.dart';
import 'package:hyprion/data/storage/testing/profile_storage_mock.dart';
import 'package:hyprion/data/system/display_manager.dart';
import 'package:hyprion/data/system/display_manager_impl.dart';
import 'package:hyprion/data/system/testing/display_mamager_mock.dart';
import 'package:hyprion/ui/guard/bloc/guard_cubit.dart';
import 'package:hyprion/ui/home/bloc/home_cubit.dart';
import 'package:hyprion/ui/profile/bloc/profile_cubit.dart';

final getIt = GetIt.instance;

void initDependencies({bool useMocks = false}) {
  if (!useMocks) {
    _initData();
  } else {
    _initDataMocks();
  }
  _initBlocs();
}

void _initData() {
  getIt.registerLazySingleton<Dependencies>(() => HyprlandDependencies());
  getIt.registerLazySingleton<ProfileStorage>(
    () => ProfileStorageImpl(appName: 'hyprion'),
  );
  getIt.registerLazySingleton<DisplayManager>(
    () => DisplayManagerImpl(getIt()),
  );
}

void _initDataMocks() {
  getIt.registerLazySingleton<Dependencies>(() => DependenciesMock());
  getIt.registerLazySingleton<ProfileStorage>(() => ProfileStorageMock());
  getIt.registerLazySingleton<DisplayManager>(
    () => DisplayManagerMock(behavior: DisplayManagerMockBehavior.normal()),
  );
}

void _initBlocs() {
  getIt.registerFactory<GuardCubit>(() => GuardCubit(getIt()));
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt()));
  getIt.registerFactory<ProfileCubit>(() => ProfileCubit(getIt(), getIt()));
}
