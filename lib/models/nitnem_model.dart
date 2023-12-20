class NitnemModel{
  final int id;
  final String gurmukhi;
  final String english;
  NitnemModel({
    required this.id,
    required this.gurmukhi,
    required this.english
  });

  factory NitnemModel.fromJson(Map<String, dynamic> json){
    return NitnemModel(
      id: json['id'],
      gurmukhi: json['name_gurmukhi'],
      english: json['name_english']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "id": id,
      "gurmukhi": gurmukhi,
      "english": english
    };
  }
}