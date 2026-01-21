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

  Future<bool> checkPasscode(String passcode) {
    // TODO: Implement.
    return Future.value(false);
  }

  Future<void> setPasscode(String passcode) {
    return _storage.write(key: _passcodeKey, value: passcode);
  }

  void deletePasscode() {
    _storage.delete(key: _passcodeKey);
  }

  Future<bool> isBiometricsEnabled() {
    // TODO: Implement
    return Future.value(false);
  }

  void setBiometricsEnabled(bool enabled) {
    // TODO: Implement
  }
}
