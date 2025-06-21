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

Future<bool> writeJsonBackupFileToDatabase(String path, RootIsolateToken rootIsolateToken) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

  final providerContainer = ProviderContainer();
  final isar = await providerContainer.read(isarProvider);

  try {
    File file = File(path);

    final content = await file.readAsString();
    final jsonContent = jsonDecode(content) as Map<String, dynamic>;

    isar.writeTxnSync(()  {
      isar.walletEntitys.putAllSync(_jsonToWalletList(jsonContent[_keyWallets]));
      isar.transactionCategoryEntitys.putAllSync(_jsonToTransactionCategoryList(jsonContent[_keyCategories]));
      isar.transactionEntitys.putAllSync(_jsonToTransactionList(jsonContent[_keyTransactions]));
    });

    return Future.value(true);
  } catch (e) {
    return Future.value(false);
  }
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
