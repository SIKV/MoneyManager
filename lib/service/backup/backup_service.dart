import 'dart:isolate';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import 'backup_result_status.dart';
import 'utils.dart';

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

  Future<BackupResultStatus> importJsonFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    final path = result?.files.single.path;

    if (path != null) {
      RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
      final writeResult = await Isolate.run(() => writeJsonBackupFileToDatabase(path, rootIsolateToken));

      if (writeResult) {
        return Future.value(BackupResultStatus.success);
      } else {
        return Future.value(BackupResultStatus.error);
      }
    } else {
      // User canceled the picker.
      return Future.value(BackupResultStatus.canceled);
    }
  }
}
