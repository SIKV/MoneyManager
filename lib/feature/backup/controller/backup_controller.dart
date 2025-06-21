import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/backup/domain/backup_state.dart';

import '../../../service/providers.dart';

final backupControllerProvider = NotifierProvider.autoDispose<BackupController, BackupState>(() {
  return BackupController();
});

class BackupController extends AutoDisposeNotifier<BackupState> {

  @override
  BackupState build() {
    return const BackupState(
      exportInProgress: false,
      exportResult: null,
      importInProgress: false,
      importResult: null,
    );
  }

  void markResultsAsHandled() {
    _updateState((state) => state.copyWith(
      exportResult: null,
      importResult: null,
    ));
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

  void importJsonFile() async {
    _updateState((state) => state.copyWith(importInProgress: true));

    final backupService = ref.watch(backupServiceProvider);
    final result = await backupService.importJsonFile();

    _updateState((state) => state.copyWith(
      importInProgress: false,
      importResult: result,
    ));
  }

  Future<void> _updateState(BackupState Function(BackupState state) update) async {
    final currentState = state;
    state = update(currentState);
  }
}
