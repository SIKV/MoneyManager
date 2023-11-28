import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/widgets.dart';

typedef OnEmojiSelected = void Function(String emoji);

class EmojiPickerContent extends StatelessWidget {
  final OnEmojiSelected onEmojiSelected;

  const EmojiPickerContent({
    Key? key,
    required this.onEmojiSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmojiPicker(
      onEmojiSelected: (category, emoji) {
        onEmojiSelected(emoji.emoji);
      },
    );
  }
}
