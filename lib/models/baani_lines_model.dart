class BaaniLineModel {
  BaaniLineModel({
    required this.shabadId,
    required this.sourcePage,
    this.sourceLine,
    required this.firstLetters,
    required this.vishraamFirstLetters,
    required this.gurmukhi,
    this.pronunciation,
    this.pronunciationInformation,
    required this.typeId,
    required this.orderId,
    this.englishTransliteration,
    this.punjabiTransliteration,
    this.spanishTransliteration,
    this.hindiTransliteration,
    this.urduTransliteration,
  });
  late final String shabadId;
  late final int sourcePage;
  late final int? sourceLine;
  late final String firstLetters;
  late final String vishraamFirstLetters;
  late final String gurmukhi;
  late final String? pronunciation;
  late final String? pronunciationInformation;
  late final int? typeId;
  late final int orderId;
  String? englishTransliteration;
  String? punjabiTransliteration;
  String? spanishTransliteration;
  String? hindiTransliteration;
  String? urduTransliteration;
  String? translationPunjabiTeeka;
  String? translationPunjabi;
  String? translationEnglish;
  String? translationFaridkotTeeka;
  String? translationHindi;
  String? translationHindiTeeka;


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
    englishTransliteration = json['english_transliteration'];
    punjabiTransliteration = json['punjabi_transliteration'];
    spanishTransliteration = json['spanish_transliteration'];
    hindiTransliteration = json['hindi_transliteration'];
    urduTransliteration = json['urdu_transliteration'];
    translationPunjabiTeeka = json['translation_punjabi_teeka'];
    translationPunjabi = json['translation_punjabi'];
    translationEnglish = json['translation_english'];
    translationFaridkotTeeka = json['translation_faridkot_teeka'];
    translationHindi = json['translation_hindi'];
    translationHindiTeeka = json['translation_hindi_teeka'];
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
    _data['english_transliteration'] = englishTransliteration;
    _data['punjabi_transliteration'] = punjabiTransliteration;
    _data['spanish_transliteration'] = spanishTransliteration;
    _data['hindi_transliteration'] = hindiTransliteration;
    _data['urdu_transliteration'] = urduTransliteration;
    _data['translation_punjabi_teeka'] = translationPunjabiTeeka;
    _data['translation_punjabi'] = translationPunjabi;
    _data['translation_english'] = translationEnglish;
    _data['translation_faridkot_teeka'] = translationFaridkotTeeka;
    _data['translation_hindi'] = translationHindi;
    _data['translation_hindi_teeka'] = translationHindiTeeka;
    return _data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BaaniLineModel && runtimeType == other.runtimeType && orderId == other.orderId;

  @override
  int get hashCode => orderId.hashCode;
}