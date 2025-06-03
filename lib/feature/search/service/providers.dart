import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/search/service/search_service.dart';

import '../../../data/providers.dart';

final searchServiceProvider = Provider.autoDispose((ref) async {
  final transactionsRepository = await ref.read(transactionsRepositoryProvider);
  final categoriesRepository = await ref.read(categoriesRepositoryProvider);

  return SearchService(transactionsRepository, categoriesRepository);
});
