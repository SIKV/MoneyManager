import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:moneymanager/data/local/entity/account_entity.dart';

import 'datasource/accounts_local_data_source.dart';

final accountsLocalDataSourceProvider = FutureProvider((_) async {
  final isar = await Isar.open([AccountEntitySchema]);
  return AccountsLocalDataSource(isar);
});
