class Reel {
  final String id;
  final String title;
  final String url;
  final String category;
  final String notes;
  final bool isDone;
  final DateTime savedAt;

  const Reel({
    required this.id,
    required this.title,
    required this.url,
    required this.category,
    this.notes = '',
    this.isDone = false,
    required this.savedAt,
  });

  String get sourceDomain {
    final u = url.toLowerCase();
    if (u.contains('instagram.com') || u.contains('instagr.am')) return 'Instagram';
    if (u.contains('youtube.com') || u.contains('youtu.be')) return 'YouTube';
    if (u.contains('tiktok.com')) return 'TikTok';
    if (u.contains('twitter.com') || u.contains('x.com')) return 'X';
    return 'Link';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'url': url,
    'category': category,
    'notes': notes,
    'isDone': isDone,
    'savedAt': savedAt.toIso8601String(),
  };

  factory Reel.fromJson(Map<String, dynamic> json) => Reel(
    id: json['id'] as String,
    title: json['title'] as String,
    url: json['url'] as String,
    category: json['category'] as String,
    notes: json['notes'] as String? ?? '',
    isDone: json['isDone'] as bool? ?? false,
    savedAt: DateTime.parse(json['savedAt'] as String),
  );

  Reel copyWith({
    String? title,
    String? url,
    String? category,
    String? notes,
    bool? isDone,
  }) =>
    Reel(
      id: id,
      title: title ?? this.title,
      url: url ?? this.url,
      category: category ?? this.category,
      notes: notes ?? this.notes,
      isDone: isDone ?? this.isDone,
      savedAt: savedAt,
    );
}
