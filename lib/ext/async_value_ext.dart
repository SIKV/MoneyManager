import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueExt<T> on AsyncValue<T> {

  Widget handleData(Widget Function(T data)? data) {
    return maybeWhen(
      data: data,
      orElse: () { throw Exception('Unexpected AsyncValue state.'); },
    );
  }
}
