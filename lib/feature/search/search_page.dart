import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/search/controller/search_controller.dart';
import 'package:moneymanager/feature/search/ui/search_result_list.dart';
import 'package:moneymanager/theme/spacings.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/assets.dart';
import '../../ui/widget/SvgIcon.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  late TextEditingController _searchTextController;

  @override
  void initState() {
    super.initState();

    _searchTextController = TextEditingController();
  }

  @override
  void dispose() {
    _searchTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _listenErrors(context, ref);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Spacings.four),
                  child: SearchBar(
                    autoFocus: true,
                    controller: _searchTextController,
                    leading: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    trailing: [
                      IconButton(
                        onPressed: () {
                          _performSearch(ref, _searchTextController.text);
                        },
                        icon: const SvgIcon(Assets.search),
                      ),
                    ],
                    hintText: AppLocalizations.of(context)!
                        .searchPage_searchBarHint,
                    onSubmitted: (query) => _performSearch(ref, query),
                  ),
                )
            ),

            const SearchResultList(),
          ],
        ),
      ),
    );
  }

  void _performSearch(WidgetRef ref, String query) {
    ref.read(searchControllerProvider.notifier)
        .search(query);
  }

  void _listenErrors(BuildContext context, WidgetRef ref) {
    ref.listen(searchControllerProvider.selectAsync((value) => value.error), (prev, next) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.searchPage_errorEmptyQuery))
      );

      ref.read(searchControllerProvider.notifier)
          .markErrorAsShown();
    });
  }
}
