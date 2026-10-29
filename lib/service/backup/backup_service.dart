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

  /// Creates a backup file and opens the share sheet for it.
  ///
  /// [sharePositionOrigin] is where the share sheet is anchored on iPad and on iOS 26+.
  Future<BackupResultStatus> exportJsonFile({Rect? sharePositionOrigin}) async {
    _canceled = false;

    RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
    final file = await Isolate.run(() => createJsonBackupFile(rootIsolateToken));

    try {
      if (_canceled) {
        return BackupResultStatus.canceled;
      }

      final xFile = XFile(file.path);

      ShareParams shareParams = ShareParams(
        files: [xFile],
        sharePositionOrigin: sharePositionOrigin,
      );
      final result = await SharePlus.instance.share(shareParams);

      return result.status.toBackupResultStatus();
    } finally {
      await file.delete();
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
