import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AutoDisposeAsyncNotifierExt<T> extends AutoDisposeAsyncNotifier<T> {

  @protected
  void updateState(T Function(T state) update) async {
    final currentState = await future;
    state = AsyncValue.data(update(currentState));
  }
}
