import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../service/backup/backup_result_status.dart';
import 'backup_import_summary.dart';

part 'backup_state.freezed.dart';

@freezed
class BackupState with _$BackupState {
  const factory BackupState({
    required bool exportInProgress,
    required BackupResultStatus? exportResult,
    required bool importInProgress,
    required BackupResultStatus? importResult,
    // Not null while a read backup file is waiting for the user to confirm the import.
    required BackupImportSummary? importConfirmation,
  }) = _BackupState;
}
