import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moneymanager/data/providers.dart';
import 'package:moneymanager/data/repository/categories_repository.dart';
import 'package:moneymanager/feature/app/app_startup.dart';
import 'package:moneymanager/local_preferences.dart';
import 'package:moneymanager/service/passcode/passcode_service.dart';
import 'package:moneymanager/service/providers.dart';

class LocalPreferencesMock extends Mock implements LocalPreferences { }

class CategoriesRepositoryMock extends Mock implements CategoriesRepository { }

class PasscodeServiceMock extends Mock implements PasscodeService { }

void main() {
  late LocalPreferencesMock localPreferences;
  late CategoriesRepositoryMock categoriesRepository;
  late PasscodeServiceMock passcodeService;

  setUp(() {
    localPreferences = LocalPreferencesMock();
    categoriesRepository = CategoriesRepositoryMock();
    passcodeService = PasscodeServiceMock();

    when(() => categoriesRepository.initWithDefaultsIfEmpty()).thenAnswer((_) async {});
    when(() => passcodeService.deletePasscode()).thenAnswer((_) async {});
  });

  Future<void> runAppStartup({required bool isFirstLaunch}) async {
    when(() => localPreferences.isFirstLaunch()).thenReturn(isFirstLaunch);

    final container = ProviderContainer(overrides: [
      localPreferencesProvider.overrideWithValue(localPreferences),
      categoriesRepositoryProvider.overrideWithValue(Future.value(categoriesRepository)),
      passcodeServiceProvider.overrideWithValue(passcodeService),
    ]);
    addTearDown(container.dispose);

    await container.read(appStartupProvider.future);
  }

  test('First launch deletes a passcode left over from a previous install', () async {
    await runAppStartup(isFirstLaunch: true);

    verify(() => passcodeService.deletePasscode()).called(1);
  });

  test('Later launches keep the passcode', () async {
    await runAppStartup(isFirstLaunch: false);

    verifyNever(() => passcodeService.deletePasscode());
  });
}
