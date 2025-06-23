// FYI: Isar (a database this app uses) requires the ID field to be an int.
int generateUniqueInt() {
  return DateTime.now().microsecondsSinceEpoch;
}

bool is24HourMode() {
  // TODO: Implement.
  return false;
}
