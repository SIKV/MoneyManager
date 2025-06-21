import 'package:share_plus/share_plus.dart';

enum BackupResultStatus {
  success, error, canceled, unknown,
}

extension Mapping on ShareResultStatus {
  BackupResultStatus toBackupResultStatus() {
    switch (this) {
      case ShareResultStatus.success:
        return BackupResultStatus.success;
      case ShareResultStatus.dismissed:
        return BackupResultStatus.canceled;
      case ShareResultStatus.unavailable:
        return BackupResultStatus.unknown;
    }
  }
}
