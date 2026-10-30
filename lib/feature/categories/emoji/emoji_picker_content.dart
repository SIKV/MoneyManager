import 'dart:math';

import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/radius.dart';
import '../../../theme/spacings.dart';
import '../../../ui/widget/close_circle_button.dart';
import '../../../ui/widget/small_section_text.dart';
import '../../../ui/widget/something_went_wrong.dart';
import 'supported_emojis_provider.dart';

typedef OnEmojiSelected = void Function(String emoji);

const _maxCellExtent = 48.0;
const _emojiFontSize = 28.0;
const _groupHeaderExtent = 40.0;

const _groupIcons = {
  EmojiGroup.smileysEmotion: Icons.emoji_emotions_outlined,
  EmojiGroup.peopleBody: Icons.emoji_people_outlined,
  EmojiGroup.animalsNature: Icons.emoji_nature_outlined,
  EmojiGroup.foodDrink: Icons.emoji_food_beverage_outlined,
  EmojiGroup.travelPlaces: Icons.emoji_transportation_outlined,
  EmojiGroup.activities: Icons.emoji_events_outlined,
  EmojiGroup.objects: Icons.emoji_objects_outlined,
  EmojiGroup.symbols: Icons.emoji_symbols_outlined,
  EmojiGroup.flags: Icons.emoji_flags_outlined,
};

class EmojiPickerContent extends ConsumerStatefulWidget {
  final OnEmojiSelected onEmojiSelected;

  const EmojiPickerContent({
    super.key,
    required this.onEmojiSelected,
  });

  @override
  ConsumerState<EmojiPickerContent> createState() => _EmojiPickerContentState();
}

class _EmojiPickerContentState extends ConsumerState<EmojiPickerContent> {
  final _scrollController = ScrollController();
  final _searchTextController = TextEditingController();

  /// Scroll offset where each group starts.
  List<double> _groupOffsets = [];
  int _selectedGroupIndex = 0;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_updateSelectedGroup);
    _searchTextController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groups = ref.watch(supportedEmojisProvider);
    final query = _searchTextController.text.trim().toLowerCase();
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      // The bottom sheet shrinks it to the available height.
      height: MediaQuery.sizeOf(context).height * 0.75 + keyboardHeight,
      child: Padding(
        padding: EdgeInsets.only(bottom: keyboardHeight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(Spacings.four),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.emojiPicker_title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const CloseCircleButton(),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacings.four),
              child: TextField(
                controller: _searchTextController,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.emojiPicker_searchHint,
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.three),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            if (query.isEmpty && groups.hasValue)
              _GroupTabs(
                groups: groups.requireValue.keys.toList(),
                selectedIndex: _selectedGroupIndex,
                onSelected: _scrollToGroup,
              )
            else
              const SizedBox(height: Spacings.two),

            Expanded(
              child: groups.when(
                data: (groups) => IndexedStack(
                  // Keeps the groups' scroll position while searching.
                  index: query.isEmpty ? 0 : 1,
                  children: [
                    _buildGroups(groups),
                    if (query.isNotEmpty) _buildSearchResults(groups, query),
                  ],
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (_, __) => const SomethingWentWrong(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroups(Map<EmojiGroup, List<Emoji>> groups) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gridWidth = constraints.maxWidth - 2 * Spacings.two;
        final columns = (gridWidth / _maxCellExtent).ceil();
        final cellExtent = gridWidth / columns;

        _groupOffsets = [];
        var offset = 0.0;
        for (final emojis in groups.values) {
          _groupOffsets.add(offset);
          offset += _groupHeaderExtent + (emojis.length / columns).ceil() * cellExtent;
        }

        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            for (final entry in groups.entries) ...[
              SliverToBoxAdapter(
                child: Container(
                  height: _groupHeaderExtent,
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacings.four,
                    vertical: Spacings.two,
                  ),
                  child: SmallSectionText(_groupTitle(context, entry.key)),
                ),
              ),
              _EmojiGrid(
                emojis: entry.value,
                onEmojiSelected: widget.onEmojiSelected,
              ),
            ],
            const _BottomSafeArea(),
          ],
        );
      },
    );
  }

  Widget _buildSearchResults(Map<EmojiGroup, List<Emoji>> groups, String query) {
    final terms = query.split(RegExp(r'\s+'));
    final results = groups.values
        .expand((emojis) => emojis)
        .where((emoji) => _matches(emoji, terms))
        .toList();

    if (results.isEmpty) {
      return Center(
        child: SmallSectionText(AppLocalizations.of(context)!.emojiPicker_noResults),
      );
    }

    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        _EmojiGrid(
          emojis: results,
          onEmojiSelected: widget.onEmojiSelected,
        ),
        const _BottomSafeArea(),
      ],
    );
  }

  /// Every search term has to be the beginning of a word in the emoji's name,
  /// keywords or subgroup (e.g. "foodFruit").
  bool _matches(Emoji emoji, List<String> terms) {
    final words = [
      ...emoji.name.toLowerCase().split(RegExp(r'[\s:,]+')),
      // Keywords like "uc6" are Unicode versions, not words.
      ...emoji.keywords.where((keyword) => !keyword.startsWith(RegExp(r'uc\d'))),
      ...emoji.emojiSubgroup.name.split(RegExp(r'(?=[A-Z])')).map((word) => word.toLowerCase()),
    ];

    return terms.every((term) => words.any((word) => word.startsWith(term)));
  }

  void _scrollToGroup(int index) {
    _scrollController.jumpTo(
      min(_groupOffsets[index], _scrollController.position.maxScrollExtent),
    );

    // The last groups may be too short to scroll to the top.
    setState(() {
      _selectedGroupIndex = index;
    });
  }

  void _updateSelectedGroup() {
    final offset = _scrollController.offset;
    final index = _groupOffsets.lastIndexWhere((groupOffset) => groupOffset <= offset + 1);

    if (index != -1 && index != _selectedGroupIndex) {
      setState(() {
        _selectedGroupIndex = index;
      });
    }
  }

  String _groupTitle(BuildContext context, EmojiGroup group) {
    final localizations = AppLocalizations.of(context)!;

    switch (group) {
      case EmojiGroup.smileysEmotion:
        return localizations.emojiPicker_smileysEmotion;
      case EmojiGroup.peopleBody:
        return localizations.emojiPicker_peopleBody;
      case EmojiGroup.animalsNature:
        return localizations.emojiPicker_animalsNature;
      case EmojiGroup.foodDrink:
        return localizations.emojiPicker_foodDrink;
      case EmojiGroup.travelPlaces:
        return localizations.emojiPicker_travelPlaces;
      case EmojiGroup.activities:
        return localizations.emojiPicker_activities;
      case EmojiGroup.objects:
        return localizations.emojiPicker_objects;
      case EmojiGroup.symbols:
        return localizations.emojiPicker_symbols;
      case EmojiGroup.flags:
        return localizations.emojiPicker_flags;
      case EmojiGroup.component:
        // Components aren't shown in the picker.
        return '';
    }
  }
}

class _GroupTabs extends StatelessWidget {
  final List<EmojiGroup> groups;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _GroupTabs({
    required this.groups,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacings.two,
        vertical: Spacings.two,
      ),
      child: Row(
        children: [
          for (final (index, group) in groups.indexed)
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.one),
                onTap: () => onSelected(index),
                child: Ink(
                  padding: const EdgeInsets.symmetric(vertical: Spacings.two),
                  decoration: BoxDecoration(
                    color: index == selectedIndex ? colorScheme.secondaryContainer : null,
                    borderRadius: BorderRadius.circular(AppRadius.one),
                  ),
                  child: Icon(_groupIcons[group],
                    color: index == selectedIndex
                        ? colorScheme.onSecondaryContainer
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmojiGrid extends StatelessWidget {
  final List<Emoji> emojis;
  final OnEmojiSelected onEmojiSelected;

  const _EmojiGrid({
    required this.emojis,
    required this.onEmojiSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: Spacings.two),
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: _maxCellExtent,
        ),
        itemCount: emojis.length,
        itemBuilder: (context, index) {
          final emoji = emojis[index];

          return InkWell(
            customBorder: const CircleBorder(),
            onTap: () => onEmojiSelected(emoji.char),
            child: Center(
              child: Text(emoji.char,
                style: const TextStyle(fontSize: _emojiFontSize),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BottomSafeArea extends StatelessWidget {
  const _BottomSafeArea();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(height: Spacings.four + MediaQuery.paddingOf(context).bottom),
    );
  }
}
