// FYI: Isar (a database this app uses) requires the ID field to be an int.
int _lastGeneratedId = 0;

int generateUniqueInt() {
  final currentTimestamp = DateTime.now().microsecondsSinceEpoch;
  
  // Ensure the new ID is always greater than the last one
  if (currentTimestamp <= _lastGeneratedId) {
    _lastGeneratedId++;
  } else {
    _lastGeneratedId = currentTimestamp;
  }
  
  return _lastGeneratedId;
}

bool is24HourMode() {
  // TODO: Implement.
  return false;
}
