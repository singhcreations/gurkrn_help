class SearchItem{
  final int id;
  final String name;

  SearchItem({required this.id, required this.name});

  factory SearchItem.fromJson(Map<String, dynamic> json) {
    return SearchItem(
      id: json['id'],
      name: json['name'],
    );
  }

  static List<SearchItem> fromJsonList(List<dynamic> json) {
    List<SearchItem> items = [];
    json.forEach((element) {
      items.add(SearchItem.fromJson(element));
    });
    return items;
  }

  @override
  String toString() {
    return 'SearchItem{id: $id, name: $name}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}