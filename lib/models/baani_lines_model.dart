class BaaniLineModel {
  BaaniLineModel({
    required this.shabadId,
    required this.sourcePage,
    required this.sourceLine,
    required this.firstLetters,
    required this.vishraamFirstLetters,
    required this.gurmukhi,
    required this.pronunciation,
    required this.pronunciationInformation,
    required this.typeId,
    required this.orderId,
  });
  late final String shabadId;
  late final int sourcePage;
  late final int sourceLine;
  late final String firstLetters;
  late final String vishraamFirstLetters;
  late final String gurmukhi;
  late final String pronunciation;
  late final String pronunciationInformation;
  late final int typeId;
  late final int orderId;

  BaaniLineModel.fromJson(Map<String, dynamic> json) {
    shabadId = json['shabad_id'];
    sourcePage = json['source_page'];
    sourceLine = json['source_line'];
    firstLetters = json['first_letters'];
    vishraamFirstLetters = json['vishraam_first_letters'];
    gurmukhi = json['gurmukhi'];
    pronunciation = json['pronunciation'];
    pronunciationInformation = json['pronunciation_information'];
    typeId = json['type_id'];
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['shabad_id'] = shabadId;
    _data['source_page'] = sourcePage;
    _data['source_line'] = sourceLine;
    _data['first_letters'] = firstLetters;
    _data['vishraam_first_letters'] = vishraamFirstLetters;
    _data['gurmukhi'] = gurmukhi;
    _data['pronunciation'] = pronunciation;
    _data['pronunciation_information'] = pronunciationInformation;
    _data['type_id'] = typeId;
    _data['order_id'] = orderId;
    return _data;
  }
}