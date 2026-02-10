// FYI: Isar (a database this app uses) requires the ID field to be an int.
// Initialize with current timestamp to avoid conflicts with existing IDs after app restart.
// Note: Dart's single-threaded execution model means thread safety is not a concern.
int _lastGeneratedId = DateTime.now().microsecondsSinceEpoch;

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
