import 'dart:io';

import 'package:isar/isar.dart';

/// Initializes Isar Core, downloading the native library if it is missing.
///
/// [Isar.initializeIsarCore] fetches the library with a plain [HttpClient].
/// When a test suite initializes `TestWidgetsFlutterBinding`, every request
/// made through [HttpClient] is answered with status code 400, which makes the
/// download fail with `Could not download IsarCore library`. Dropping the
/// overrides for the duration of the download keeps that from happening no
/// matter which bindings the suite installs.
Future<void> initializeIsarCoreForTests() async {
  final overrides = HttpOverrides.current;
  HttpOverrides.global = null;
  try {
    await Isar.initializeIsarCore(download: true);
  } finally {
    HttpOverrides.global = overrides;
  }
}
