import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:moneymanager/data/local/entity/account_entity.dart';
import 'package:moneymanager/data/local/entity/transaction_category_entity.dart';
import 'package:moneymanager/data/local/entity/transaction_entity.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/local/providers.dart';

Future<File> createJsonBackupFile(RootIsolateToken rootIsolateToken) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

  final providerContainer = ProviderContainer();
  final isar = await providerContainer.read(isarProvider);

  final dir = await getTemporaryDirectory();
  final path = '${dir.path}/MoneyManager-${DateTime.now().toString()}.json';
  final File file = File(path);

  final backupJson = await _createJsonBackupString(isar);
  await file.writeAsString(backupJson);

  return file;
}

Future<String> _createJsonBackupString(Isar isar) async {
  final accountsJson = await _toJsonMap(isar.accountEntitys);
  final categoriesJson = await _toJsonMap(isar.transactionCategoryEntitys);
  final transactionsJson = await _toJsonMap(isar.transactionEntitys);

  Map<String, dynamic> backup = {
    'accounts' : accountsJson,
    'categories' : categoriesJson,
    'transactions' : transactionsJson
  };

  return jsonEncode(backup);
}

Future<List<Map<String, dynamic>>> _toJsonMap<OBJ>(IsarCollection<OBJ> collection) async {
  return await collection.where().exportJson();
}
