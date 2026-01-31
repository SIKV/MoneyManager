import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AutoDisposeFamilyNotifierExt<T, P> extends AutoDisposeFamilyNotifier<T, P> {

  @protected
  void updateState(T Function(T state) update) async {
    state = update(state);
  }
}
