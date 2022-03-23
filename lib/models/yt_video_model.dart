import 'dart:convert';

class YtvidList {
  static List<Ytvid>? vidlist;
}

class Ytvid {
  final String? id;
  final String? title;

  Ytvid({
    this.id,
    this.title,
  });

  Ytvid copyWith({
    String? id,
    String? title,
  }) {
    return Ytvid(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  factory Ytvid.fromMap(Map<String, dynamic> map) {
    return Ytvid(
      id: map['id'],
      title: map['title'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Ytvid.fromJson(String source) => Ytvid.fromMap(json.decode(source));

  @override
  String toString() => 'Ytvid(id: $id, title: $title)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Ytvid && other.id == id && other.title == title;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode;
}
