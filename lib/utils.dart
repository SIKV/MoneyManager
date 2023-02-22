import 'package:flutter/material.dart';

String generateUniqueId() {
  return UniqueKey().toString();
}

int generateUniqueInt() {
  // TODO Find a better way to generate a random int.
  return DateTime.now().millisecond;
}
