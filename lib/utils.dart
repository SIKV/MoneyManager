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

String formatDateTime(DateTime dateTime) {
  // TODO:
  final DateFormat formatter = DateFormat('E dd  h:m a');
  return formatter.format(dateTime);
}
