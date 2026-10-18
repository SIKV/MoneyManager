import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:moneymanager/data/local/entity/transaction_category_entity.dart';
import 'package:moneymanager/data/local/entity/transaction_entity.dart';
import 'package:moneymanager/data/local/entity/wallet_entity.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/local/providers.dart';
import 'backup_data.dart';

const _keyWallets = 'wallets';
const _keyCategories = 'categories';
const _keyTransactions = 'transactions';

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

/// Reads and parses the whole backup file without touching the database.
///
/// Throws if the file is not a valid backup.
Future<BackupData> readJsonBackupFile(String path) async {
  final content = await File(path).readAsString();
  return parseJsonBackup(content);
}

BackupData parseJsonBackup(String content) {
  final jsonContent = jsonDecode(content) as Map<String, dynamic>;

  return BackupData(
    wallets: _jsonToWalletList(jsonContent[_keyWallets] as List<dynamic>),
    categories: _jsonToTransactionCategoryList(jsonContent[_keyCategories] as List<dynamic>),
    transactions: _jsonToTransactionList(jsonContent[_keyTransactions] as List<dynamic>),
  );
}

Future<bool> replaceDatabaseWithBackup(BackupData backup, RootIsolateToken rootIsolateToken) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

  final providerContainer = ProviderContainer();
  final isar = await providerContainer.read(isarProvider);

  try {
    writeBackupToDatabase(isar, backup);
    return Future.value(true);
  } catch (e) {
    return Future.value(false);
  }
}

/// Replaces all existing data with the backup.
///
/// Everything happens in a single transaction, so if anything fails, the existing data stays untouched.
void writeBackupToDatabase(Isar isar, BackupData backup) {
  isar.writeTxnSync(() {
    isar.walletEntitys.clearSync();
    isar.transactionCategoryEntitys.clearSync();
    isar.transactionEntitys.clearSync();

    isar.walletEntitys.putAllSync(backup.wallets);
    isar.transactionCategoryEntitys.putAllSync(backup.categories);
    isar.transactionEntitys.putAllSync(backup.transactions);
  });
}

List<WalletEntity> _jsonToWalletList(List<dynamic> json) {
  return json.map((e) =>
      WalletEntity.fromJson(e as Map<String, dynamic>)
  ).toList();
}

List<TransactionCategoryEntity> _jsonToTransactionCategoryList(List<dynamic> json) {
  return json.map((e) =>
      TransactionCategoryEntity.fromJson(e as Map<String, dynamic>)
  ).toList();
}

List<TransactionEntity> _jsonToTransactionList(List<dynamic> json) {
  return json.map((e) =>
      TransactionEntity.fromJson(e as Map<String, dynamic>)
  ).toList();
}

Future<String> _createJsonBackupString(Isar isar) async {
  final walletsJson = await _toJsonMap(isar.walletEntitys);
  final categoriesJson = await _toJsonMap(isar.transactionCategoryEntitys);
  final transactionsJson = await _toJsonMap(isar.transactionEntitys);

  Map<String, dynamic> backup = {
    _keyWallets : walletsJson,
    _keyCategories : categoriesJson,
    _keyTransactions : transactionsJson
  };

  return jsonEncode(backup);
}

Future<List<Map<String, dynamic>>> _toJsonMap<OBJ>(IsarCollection<OBJ> collection) async {
  return await collection.where().exportJson();
}
