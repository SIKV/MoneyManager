import 'dart:async';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/backup/domain/backup_state.dart';
import 'package:moneymanager/local_preferences.dart';
import 'package:moneymanager/service/backup/backup_data.dart';
import 'package:moneymanager/service/backup/backup_result_status.dart';

import '../../../data/providers.dart';
import '../../../service/providers.dart';

final backupControllerProvider = NotifierProvider.autoDispose<BackupController, BackupState>(() {
  return BackupController();
});

class BackupController extends AutoDisposeNotifier<BackupState> {
  // The backup that is waiting for the user to confirm the import.
  BackupData? _pendingImport;

  @override
  BackupState build() {
    return const BackupState(
      exportInProgress: false,
      exportResult: null,
      importInProgress: false,
      importResult: null,
      importConfirmationRequired: false,
    );
  }

  void markResultsAsHandled() {
    _updateState((state) => state.copyWith(
      exportResult: null,
      importResult: null,
    ));
  }

  void exportJsonFile({Rect? sharePositionOrigin}) async {
    _updateState((state) => state.copyWith(exportInProgress: true));

    final backupService = ref.watch(backupServiceProvider);

    BackupResultStatus result;
    try {
      result = await backupService.exportJsonFile(sharePositionOrigin: sharePositionOrigin);
    } catch (e) {
      result = BackupResultStatus.error;
    }

    _updateState((state) => state.copyWith(
      exportInProgress: false,
      exportResult: result,
    ));
  }

  // Set [confirmationRequired] to false to replace the data right away, e.g. when there is nothing to lose yet.
  void importJsonFile({bool confirmationRequired = true}) async {
    _updateState((state) => state.copyWith(importInProgress: true));

    final backupService = ref.watch(backupServiceProvider);

    BackupData? backup;
    try {
      backup = await backupService.readJsonFile();
    } catch (e) {
      _updateState((state) => state.copyWith(
        importInProgress: false,
        importResult: BackupResultStatus.error,
      ));
      return;
    }

    if (backup == null) {
      _updateState((state) => state.copyWith(
        importInProgress: false,
        importResult: BackupResultStatus.canceled,
      ));
      return;
    }

    _pendingImport = backup;

    if (!confirmationRequired) {
      confirmImport();
      return;
    }

    _updateState((state) => state.copyWith(
      importInProgress: false,
      importConfirmationRequired: true,
    ));
  }

  void confirmImport() async {
    final backup = _pendingImport;
    _pendingImport = null;

    if (backup == null) {
      return;
    }

    _updateState((state) => state.copyWith(
      importInProgress: true,
      importConfirmationRequired: false,
    ));

    final backupService = ref.watch(backupServiceProvider);
    final result = await backupService.replaceAllData(backup);

    if (result == BackupResultStatus.success) {
      _resetCurrentWallet(backup);

      final categoriesRepository = await ref.read(categoriesRepositoryProvider);
      categoriesRepository.notifyUpdated();
    }

    _updateState((state) => state.copyWith(
      importInProgress: false,
      importResult: result,
    ));
  }

  void cancelImport() {
    _pendingImport = null;

    _updateState((state) => state.copyWith(
      importConfirmationRequired: false,
    ));
  }

  // The current wallet might not exist after the import. Keep it if the backup has it, otherwise
  // switch to the first wallet from the backup. Set it even if unchanged so that wallet-dependent
  // screens reload the imported data.
  void _resetCurrentWallet(BackupData backup) {
    final localPreferences = ref.read(localPreferencesProvider);
    final currentWalletId = localPreferences.currentWalletId;

    final walletIds = backup.wallets.map((it) => it.id);
    final newWalletId = walletIds.contains(currentWalletId) ? currentWalletId : walletIds.firstOrNull;

    localPreferences.setCurrentWallet(newWalletId);
  }

  Future<void> _updateState(BackupState Function(BackupState state) update) async {
    final currentState = state;
    state = update(currentState);
  }
}
