// FYI: Isar (a database this app uses) requires the ID field to be an int.
// Initialize with current timestamp to avoid conflicts with existing IDs after app restart.
// Note: This generator is isolate-local and only guarantees monotonically increasing IDs within a single isolate.
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
