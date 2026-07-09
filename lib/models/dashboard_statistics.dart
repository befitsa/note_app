class DashboardStatistics {
  final int totalNotes;
  final int pinnedNotes;
  final int archivedNotes;
  final int favoriteNotes;
  final int totalCharacters;

  const DashboardStatistics({
    this.totalNotes = 0,
    this.pinnedNotes = 0,
    this.archivedNotes = 0,
    this.favoriteNotes = 0,
    this.totalCharacters = 0,
  });

  String get storageLabel {
    final bytes = totalCharacters * 2;
    if (bytes < 1024) return '$bytes B';

    final kb = bytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';

    final mb = kb / 1024;
    return '${mb.toStringAsFixed(2)} MB';
  }
}