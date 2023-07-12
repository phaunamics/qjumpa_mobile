class ShoppingListEntity {
  final String title;
  final int? id;
  bool isExpanded;
  final List<ItemBody> body;

  ShoppingListEntity({
    required this.title,
    required this.body,
    required this.id,
    this.isExpanded = false,
  });

  factory ShoppingListEntity.fromJson(Map<String, dynamic> json) {
    return ShoppingListEntity(
      title: json['title'],
      id: json['id'],
      isExpanded: json['isExpanded'] ?? false,
      body: List<ItemBody>.from(json['body'].map((x) => ItemBody.fromJson(x))),
    );
  }

  factory ShoppingListEntity.withId(
      {required List<ItemBody> body, required String title, bool? isExpanded}) {
    return ShoppingListEntity(
        id: DateTime.now().microsecondsSinceEpoch,
        body: body,
        title: title,
        isExpanded: isExpanded = false);
  }

  ShoppingListEntity copyWith(
      {String? title, List<ItemBody>? body, bool isExpanded = false, int? id}) {
    return ShoppingListEntity(
      title: title ?? this.title,
      body: body ?? this.body,
      isExpanded: isExpanded,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'id': id,
      'isExpanded': isExpanded,
      'body': List<dynamic>.from(body.map((x) => x.toJson())),
    };
  }

  @override
  String toString() {
    return 'item{title: $title, isExpanded: $isExpanded, body: $body, id:$id }';
  }
}

class ItemBody {
  final String content;
  bool isChecked;
  final int? id;

  ItemBody({
    required this.content,
    required this.id,
    this.isChecked = false,
  });

  factory ItemBody.fromJson(Map<String, dynamic> json) {
    return ItemBody(
      content: json['content'],
      id: json['id'],
      isChecked: json['isChecked'] ?? false,
    );
  }
  factory ItemBody.withId({required String content, bool? isChecked}) {
    return ItemBody(
        id: DateTime.now().millisecondsSinceEpoch,
        content: content,
        isChecked: isChecked = false);
  }

  ItemBody copyWith({
    String? content,
    int? id,
    bool isChecked = false,
  }) {
    return ItemBody(
      content: content ?? this.content,
      isChecked: isChecked = false,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'isChecked': isChecked,
    };
  }

  @override
  String toString() {
    return 'itemBody{content: $content, isChecked: $isChecked}';
  }
}
