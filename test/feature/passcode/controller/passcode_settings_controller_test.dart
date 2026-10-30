import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moneymanager/feature/passcode/controller/passcode_settings_controller.dart';
import 'package:moneymanager/service/passcode/passcode_service.dart';
import 'package:moneymanager/service/providers.dart';

class PasscodeServiceMock extends Mock implements PasscodeService { }

void main() {
  late PasscodeServiceMock passcodeService;

  setUp(() {
    passcodeService = PasscodeServiceMock();

    when(() => passcodeService.isPasscodeEnabled()).thenAnswer((_) async => true);
    when(() => passcodeService.canCheckBiometrics()).thenAnswer((_) async => true);
    when(() => passcodeService.setBiometricsEnabled(any())).thenAnswer((_) async {});
  });

  Future<ProviderContainer> createContainer({required bool biometricsEnabled}) async {
    when(() => passcodeService.isBiometricsEnabled()).thenAnswer((_) async => biometricsEnabled);

    final container = ProviderContainer(overrides: [
      passcodeServiceProvider.overrideWithValue(passcodeService),
    ]);
    addTearDown(container.dispose);

    container.listen(passcodeSettingsControllerProvider, (_, __) { });
    await container.read(passcodeSettingsControllerProvider.future);

    return container;
  }

  test('setBiometricsEnabled(true) turns biometrics on when authentication succeeds', () async {
    // GIVEN
    when(() => passcodeService.runBiometricsAuth('Reason')).thenAnswer((_) async => true);
    final container = await createContainer(biometricsEnabled: false);

    // WHEN
    container.read(passcodeSettingsControllerProvider.notifier).setBiometricsEnabled(true, 'Reason');
    await pumpEventQueue();

    // THEN
    final state = await container.read(passcodeSettingsControllerProvider.future);
    expect(state.isBiometricsEnabled, isTrue);
    verify(() => passcodeService.setBiometricsEnabled(true)).called(1);
  });

  test('setBiometricsEnabled(true) keeps biometrics off when authentication fails', () async {
    // GIVEN
    when(() => passcodeService.runBiometricsAuth('Reason')).thenAnswer((_) async => false);
    final container = await createContainer(biometricsEnabled: false);

    // WHEN
    container.read(passcodeSettingsControllerProvider.notifier).setBiometricsEnabled(true, 'Reason');
    await pumpEventQueue();

    // THEN
    final state = await container.read(passcodeSettingsControllerProvider.future);
    expect(state.isBiometricsEnabled, isFalse);
    verifyNever(() => passcodeService.setBiometricsEnabled(any()));
  });

  test('setBiometricsEnabled(false) turns biometrics off without authentication', () async {
    // GIVEN
    final container = await createContainer(biometricsEnabled: true);

    // WHEN
    container.read(passcodeSettingsControllerProvider.notifier).setBiometricsEnabled(false, 'Reason');
    await pumpEventQueue();

    // THEN
    final state = await container.read(passcodeSettingsControllerProvider.future);
    expect(state.isBiometricsEnabled, isFalse);
    verifyNever(() => passcodeService.runBiometricsAuth(any()));
    verify(() => passcodeService.setBiometricsEnabled(false)).called(1);
  });
}
