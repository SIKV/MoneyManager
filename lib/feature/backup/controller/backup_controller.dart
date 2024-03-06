import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/backup/domain/backup_state.dart';
import 'package:moneymanager/service/providers.dart';

final backupControllerProvider = NotifierProvider.autoDispose<BackupController, BackupState>(() {
  return BackupController();
});

class BackupController extends AutoDisposeNotifier<BackupState> {

  @override
  BackupState build() {
    return const BackupState(
      exportInProgress: false,
      exportResult: null,
    );
  }

  void exportJsonFile() async {
    _updateState((state) => state.copyWith(exportInProgress: true));

    final backupService = ref.watch(backupServiceProvider);
    final result = await backupService.exportJsonFile();

    _updateState((state) => state.copyWith(
      exportInProgress: false,
      exportResult: result,
    ));
  }

  Future<void> _updateState(BackupState Function(BackupState state) update) async {
    final currentState = state;
    state = update(currentState);
  }
}
