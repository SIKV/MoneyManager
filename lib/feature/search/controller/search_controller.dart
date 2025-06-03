import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/search/domain/search_error.dart';
import 'package:moneymanager/feature/search/domain/search_state.dart';
import 'package:moneymanager/feature/search/service/search_service.dart';

import '../../../common/currency_formatter.dart';
import '../../../ext/auto_dispose_async_notifier_ext.dart';
import '../../common/transaction_ui_model_mapper.dart';
import '../service/providers.dart';

final searchControllerProvider = AsyncNotifierProvider.autoDispose<SearchController, SearchState>(() {
  return SearchController();
});

class SearchController extends AutoDisposeAsyncNotifierExt<SearchState> {

  @override
  FutureOr<SearchState> build() {
    return const SearchState(
      didSearch: false,
      searchResult: [],
      error: null,
    );
  }

  void search(String query) async {
    var trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      updateState((state) => state.copyWith(
          didSearch: true,
          searchResult: [],
          error: SearchError.emptyQuery
      ));
    } else {
      SearchService searchService = await ref.read(searchServiceProvider);
      var result = await searchService.search(trimmedQuery);

      final currencyFormatter = ref.read(currencyFormatterProvider);
      final mapper = TransactionUiModelMapper(currencyFormatter);

      updateState((state) => state.copyWith(
          didSearch: true,
          searchResult: mapper.map(result)
      ));
    }
  }

  void markErrorAsShown() {
    updateState((state) => state.copyWith(error: null));
  }
}
