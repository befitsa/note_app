/// Category a note can belong to.
enum NoteCategory { personal, work, ideas, todo, other }

/// Options for sorting the notes list.
enum SortOption { dateModified, dateCreated, title, category }

/// Which tab/filter is active on the Home screen.
enum HomeFilter { all, pinned, favorites, archived }

extension NoteCategoryX on NoteCategory {
  String get label {
    switch (this) {
      case NoteCategory.personal:
        return 'Personal';
      case NoteCategory.work:
        return 'Work';
      case NoteCategory.ideas:
        return 'Ideas';
      case NoteCategory.todo:
        return 'To-Do';
      case NoteCategory.other:
        return 'Other';
    }
  }
}

extension SortOptionX on SortOption {
  String get label {
    switch (this) {
      case SortOption.dateModified:
        return 'Last Modified';
      case SortOption.dateCreated:
        return 'Date Created';
      case SortOption.title:
        return 'Title';
      case SortOption.category:
        return 'Category';
    }
  }
}
