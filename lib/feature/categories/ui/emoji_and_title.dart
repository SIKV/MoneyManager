import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../theme/spacings.dart';
import '../domain/category_maker_state.dart';

const _emojiContainerSize = 48.0;
const _emojiFontSize = 24.0;

class EmojiAndTitle extends StatelessWidget {
  final CategoryMakerState state;
  final TextEditingController titleTextController;
  final VoidCallback? onSelectEmoji;

  const EmojiAndTitle({
    super.key,
    required this.state,
    required this.titleTextController,
    required this.onSelectEmoji,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onSelectEmoji,
          child: Container(
            height: _emojiContainerSize,
            width: _emojiContainerSize,
            padding: const EdgeInsets.all(Spacings.two),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.primary,
              ),
              shape: BoxShape.circle,
            ),
            child: Text(state.category.emoji ?? '',
              style: const TextStyle(
                fontSize: _emojiFontSize,
              ),
            ),
          ),
        ),

        const SizedBox(width: Spacings.five),

        Expanded(
          child: TextField(
            controller: titleTextController,
            autofocus: true,
            maxLength: state.titleMaxLength,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.categoryTitle,
            ),
          ),
        ),
      ],
    );
  }
}
