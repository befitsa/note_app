import '../shared/enums/note_enums.dart';

/// Core data model representing a single note.
class NoteModel {
  final String id;
  String title;
  String content;
  NoteCategory category;
  int colorValue;
  bool isPinned;
  bool isFavorite;
  bool isArchived;
  final DateTime createdAt;
  DateTime updatedAt;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    this.category = NoteCategory.other,
    required this.colorValue,
    this.isPinned = false,
    this.isFavorite = false,
    this.isArchived = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Character count, used for the auto-save character counter and for
  /// the "Storage Statistics" figure on the dashboard.
  int get characterCount => content.length;

  NoteModel copyWith({
    String? title,
    String? content,
    NoteCategory? category,
    int? colorValue,
    bool? isPinned,
    bool? isFavorite,
    bool? isArchived,
    DateTime? updatedAt,
  }) {
    return NoteModel(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      colorValue: colorValue ?? this.colorValue,
      isPinned: isPinned ?? this.isPinned,
      isFavorite: isFavorite ?? this.isFavorite,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'category': category.index,
        'colorValue': colorValue,
        'isPinned': isPinned,
        'isFavorite': isFavorite,
        'isArchived': isArchived,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      category: NoteCategory.values[(json['category'] as int?) ?? 0],
      colorValue: json['colorValue'] as int? ?? 0xFFFFFFFF,
      isPinned: json['isPinned'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
      isArchived: json['isArchived'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
