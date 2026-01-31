import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO: Disable backups.

class PasscodeService {
  final FlutterSecureStorage _secureStorage;
  final SharedPreferencesAsync _sharedPreferences;
  final LocalAuthentication _localAuth;

  PasscodeService(this._secureStorage, this._sharedPreferences, this._localAuth);

  final _passcodeKey = "passcode";
  final _biometricsEnabledKey = "biometricsEnabled";

  Future<bool> isPasscodeEnabled() {
    return _secureStorage.containsKey(key: _passcodeKey);
  }

  Future<bool> verifyPasscode(String passcode) async {
    final storedPasscode = await _secureStorage.read(key: _passcodeKey);
    return passcode == storedPasscode;
  }

  Future<void> setPasscode(String passcode) {
    return _secureStorage.write(key: _passcodeKey, value: passcode);
  }

  Future<void> deletePasscode() {
    return _secureStorage.delete(key: _passcodeKey);
  }

  Future<bool> isBiometricsEnabled() async {
    final biometricsEnabled = await _sharedPreferences.getBool(_biometricsEnabledKey);
    return biometricsEnabled ?? false;
  }

  Future<bool> canCheckBiometrics() async {
    return _localAuth.isDeviceSupported();
  }

  Future<bool> runBiometricsAuth() async {
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to continue.', // TODO: Translate.
      );
      return authenticated;
    } catch (e) {
      // TODO: Log error?
      return false;
    }
  }

  Future<void> setBiometricsEnabled(bool enabled) async {
    return await _sharedPreferences.setBool(_biometricsEnabledKey, enabled);
  }
}
