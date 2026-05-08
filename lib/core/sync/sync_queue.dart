enum SyncStatus { localOnly, pending, synced, failed, conflict }

class ConflictResolver {
  const ConflictResolver();

  bool isDuplicate({
    required String type,
    required DateTime first,
    required DateTime second,
  }) {
    return type.isNotEmpty && first.difference(second).abs().inMinutes <= 1;
  }
}
