import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../service/backup/backup_result_status.dart';

part 'backup_state.freezed.dart';

@freezed
class BackupState with _$BackupState {
  const factory BackupState({
    required bool exportInProgress,
    required BackupResultStatus? exportResult,
  }) = _BackupState;
}
