import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// TODO: Disable backups.
class PasscodeService {
  final FlutterSecureStorage _storage;

  PasscodeService(this._storage);

  final _passcodeKey = "passcode";
  final _biometricsEnabledKey = "biometricsEnabled";

  Future<bool> isPasscodeEnabled() {
    return _storage.containsKey(key: _passcodeKey);
  }

  Future<bool> verifyPasscode(String passcode) async {
    final storedPasscode = await _storage.read(key: _passcodeKey);
    return passcode == storedPasscode;
  }

  Future<void> setPasscode(String passcode) {
    return _storage.write(key: _passcodeKey, value: passcode);
  }

  Future<void> deletePasscode() {
    return _storage.delete(key: _passcodeKey);
  }

  Future<bool> isBiometricsEnabled() {
    // TODO: Implement
    return Future.value(false);
  }

  void setBiometricsEnabled(bool enabled) {
    // TODO: Implement
  }
}
