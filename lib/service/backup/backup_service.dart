import 'dart:isolate';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import 'backup_data.dart';
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

  /// Lets the user pick a backup file and reads it without touching the database.
  ///
  /// Returns null if the user canceled the picker. Throws if the file is not a valid backup.
  Future<BackupData?> readJsonFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    final path = result?.files.single.path;

    if (path != null) {
      return Isolate.run(() => readJsonBackupFile(path));
    } else {
      // User canceled the picker.
      return null;
    }
  }

  /// Replaces all existing data with the backup.
  Future<BackupResultStatus> replaceAllData(BackupData backup) async {
    RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
    final writeResult = await Isolate.run(() => replaceDatabaseWithBackup(backup, rootIsolateToken));

    if (writeResult) {
      return BackupResultStatus.success;
    } else {
      return BackupResultStatus.error;
    }
  }
}
