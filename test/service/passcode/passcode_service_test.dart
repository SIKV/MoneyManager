import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moneymanager/service/passcode/passcode_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlutterSecureStorageMock extends Mock implements FlutterSecureStorage {}

class SharedPreferencesAsyncMock extends Mock implements SharedPreferencesAsync {}

class LocalAuthenticationMock extends Mock implements LocalAuthentication {}

void main() {
  late PasscodeService service;
  late FlutterSecureStorageMock secureStorage;
  late SharedPreferencesAsyncMock sharedPreferences;
  late LocalAuthenticationMock localAuth;

  setUp(() {
    secureStorage = FlutterSecureStorageMock();
    sharedPreferences = SharedPreferencesAsyncMock();
    localAuth = LocalAuthenticationMock();

    service = PasscodeService(secureStorage, sharedPreferences, localAuth);
  });

  test('isPasscodeEnabled() returns the value from secure storage', () async {
    when(() => secureStorage.containsKey(key: 'passcode'))
        .thenAnswer((_) async => true);

    final result = await service.isPasscodeEnabled();

    expect(result, isTrue);
    verify(() => secureStorage.containsKey(key: 'passcode')).called(1);
  });

  test('verifyPasscode() returns true when passcode matches stored value', () async {
    when(() => secureStorage.read(key: 'passcode'))
        .thenAnswer((_) async => '1234');

    final result = await service.verifyPasscode('1234');

    expect(result, isTrue);
    verify(() => secureStorage.read(key: 'passcode')).called(1);
  });

  test('verifyPasscode() returns false when passcode does not match stored value', () async {
    when(() => secureStorage.read(key: 'passcode'))
        .thenAnswer((_) async => '1234');

    final result = await service.verifyPasscode('4321');

    expect(result, isFalse);
    verify(() => secureStorage.read(key: 'passcode')).called(1);
  });

  test('setPasscode() writes the passcode to secure storage', () async {
    when(() => secureStorage.write(key: 'passcode', value: '1234'))
        .thenAnswer((_) async {});

    await service.setPasscode('1234');

    verify(() => secureStorage.write(key: 'passcode', value: '1234')).called(1);
  });

  test('deletePasscode() removes the passcode from secure storage', () async {
    when(() => secureStorage.delete(key: 'passcode'))
        .thenAnswer((_) async {});

    await service.deletePasscode();

    verify(() => secureStorage.delete(key: 'passcode')).called(1);
  });

  test('isBiometricsEnabled() returns stored biometrics value', () async {
    when(() => sharedPreferences.getBool('biometricsEnabled'))
        .thenAnswer((_) async => true);

    final result = await service.isBiometricsEnabled();

    expect(result, isTrue);
    verify(() => sharedPreferences.getBool('biometricsEnabled')).called(1);
  });

  test('isBiometricsEnabled() returns false when no value is stored', () async {
    when(() => sharedPreferences.getBool('biometricsEnabled'))
        .thenAnswer((_) async => null);

    final result = await service.isBiometricsEnabled();

    expect(result, isFalse);
    verify(() => sharedPreferences.getBool('biometricsEnabled')).called(1);
  });

  test('canCheckBiometrics() returns device support from local auth', () async {
    when(() => localAuth.isDeviceSupported())
        .thenAnswer((_) async => true);

    final result = await service.canCheckBiometrics();

    expect(result, isTrue);
    verify(() => localAuth.isDeviceSupported()).called(1);
  });

  test('runBiometricsAuth() returns authentication result', () async {
    when(() => localAuth.authenticate(localizedReason: 'Unlock app'))
        .thenAnswer((_) async => true);

    final result = await service.runBiometricsAuth('Unlock app');

    expect(result, isTrue);
    verify(() => localAuth.authenticate(localizedReason: 'Unlock app')).called(1);
  });

  test('runBiometricsAuth() returns false when authentication throws', () async {
    when(() => localAuth.authenticate(localizedReason: 'Unlock app'))
        .thenThrow(Exception('biometrics unavailable'));

    final result = await service.runBiometricsAuth('Unlock app');

    expect(result, isFalse);
    verify(() => localAuth.authenticate(localizedReason: 'Unlock app')).called(1);
  });

  test('setBiometricsEnabled() stores biometrics preference', () async {
    when(() => sharedPreferences.setBool('biometricsEnabled', true))
        .thenAnswer((_) async {});

    await service.setBiometricsEnabled(true);

    verify(() => sharedPreferences.setBool('biometricsEnabled', true)).called(1);
  });
}
