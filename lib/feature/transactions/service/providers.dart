import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/transactions/service/filter_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final filterServiceProvider = Provider((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return FilterService(prefs);
});
