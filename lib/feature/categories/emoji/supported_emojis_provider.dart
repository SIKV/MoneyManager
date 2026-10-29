import 'dart:math';
import 'dart:ui' as ui;

import 'package:collection/collection.dart';
import 'package:emojis/emoji.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Emojis the device can display, grouped by category in the Unicode order.
/// Computed once per app launch.
final supportedEmojisProvider = FutureProvider<Map<EmojiGroup, List<Emoji>>>((ref) async {
  final emojis = Emoji.all()
      .where((emoji) =>
          emoji.emojiGroup != EmojiGroup.component &&
          emoji.emojiSubgroup != EmojiSubgroup.regional &&
          !emoji.char.runes.any(_isSkinTone))
      .toList();

  final supported = await _filterSupported(emojis);

  return groupBy(supported, (emoji) => emoji.emojiGroup);
});

bool _isSkinTone(int rune) => rune >= 0x1F3FB && rune <= 0x1F3FF;

/// Emojis newer than the device's emoji font are drawn as empty boxes
/// or as several separate emojis, so they're left out.
///
/// All emojis are drawn into one image in pure magenta. A missing glyph box
/// is drawn in that color and has no green in it, while every emoji glyph does.
Future<List<Emoji>> _filterSupported(List<Emoji> emojis) async {
  const style = TextStyle(fontSize: 12, color: Color(0xFFFF00FF));
  const columns = 64;

  TextPainter layout(String text) => TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
  )..layout();

  final reference = layout('😀');
  final cell = max(reference.width, reference.height).ceil();
  final painters = [for (final emoji in emojis) layout(emoji.char)];

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  for (var i = 0; i < painters.length; i++) {
    final rect = Rect.fromLTWH(
      (i % columns * cell).toDouble(),
      (i ~/ columns * cell).toDouble(),
      cell.toDouble(),
      cell.toDouble(),
    );
    canvas.save();
    canvas.clipRect(rect);
    painters[i].paint(canvas, rect.topLeft);
    canvas.restore();
  }

  final width = columns * cell;
  final image = await recorder.endRecording()
      .toImage(width, (painters.length / columns).ceil() * cell);
  final pixels = (await image.toByteData())!;
  image.dispose();

  bool hasGreen(int index) {
    final left = index % columns * cell;
    final top = index ~/ columns * cell;
    for (var y = top; y < top + cell; y++) {
      for (var x = left; x < left + cell; x++) {
        if (pixels.getUint8((y * width + x) * 4 + 1) > 0) {
          return true;
        }
      }
    }
    return false;
  }

  final supported = [
    for (var i = 0; i < emojis.length; i++)
      if (painters[i].width < reference.width * 1.5 && hasGreen(i))
        emojis[i],
  ];

  reference.dispose();
  for (final painter in painters) {
    painter.dispose();
  }

  return supported;
}
