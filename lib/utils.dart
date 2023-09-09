import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String generateUniqueId() {
  return UniqueKey().toString();
}

int generateUniqueInt() {
  // TODO Find a better way to generate a random int.
  return DateTime.now().millisecond;
}

bool is24HourMode() {
  // TODO: Implement.
  return false;
}
