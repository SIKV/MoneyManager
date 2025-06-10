import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../domain/backup_result_status.dart';
import 'export.dart';

class BackupService {
  bool _canceled = false;

  BackupService();

  void cancel() {
    _canceled = true;
  }

  Future<BackupResultStatus> exportJsonFile() async {
    _canceled = false;

    RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
    final file = await Isolate.run(() => createJsonBackupFile(rootIsolateToken));

    if (!_canceled) {
      final xFile = XFile(file.path);

      ShareParams shareParams = ShareParams(
        files: [xFile],
      );
      final result = await SharePlus.instance.share(shareParams);

      await file.delete();

      return result.status.toBackupResultStatus();
    } else {
      return BackupResultStatus.canceled;
    }
  }
}
