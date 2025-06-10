import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/backup/service/backup_service.dart';

final backupServiceProvider = Provider.autoDispose((ref) {
  final backupService = BackupService();

  ref.onDispose(() {
    backupService.cancel();
  });

  return backupService;
});
