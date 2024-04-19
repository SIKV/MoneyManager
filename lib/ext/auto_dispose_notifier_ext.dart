import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AutoDisposeNotifierExt<T> extends AutoDisposeNotifier<T> {

  @protected
  void updateState(T Function(T state) update) async {
    state = update(state);
  }
}
