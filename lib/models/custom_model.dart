import 'dart:ui';

class CustomModel {
  String? title;
  String? subTitle;
  String? description;
  String? icon;
  Color? color;
  String? img;

  CustomModel(
      {this.title,
      this.subTitle,
      this.description,
      this.icon,
      this.color,
      this.img});
}

//Nitnem
List<CustomModel> nitnemScreenList = [
  CustomModel(title: "ਮੂਲ ਮੰਤਰ ਸਾਹਿਬ", subTitle: "मूल मंतर साहिब"),
  CustomModel(title: "ਜਪੁਜੀ ਸਾਹਿਬ", subTitle: "जपुजी साहिब"),
  CustomModel(title: "ਜਾਪੁ ਸਾਹਿਬ", subTitle: "जापु साहिब"),
  CustomModel(title: "ਤ੍ਵ ਪ੍ਰਸਾਦਿ ਸ੍ਵੈਯੇ", subTitle: "व प्रसादि सव्ये"),
  CustomModel(title: "ਚੌਪਈ ਸਾਹਿਬ", subTitle: "चौपाइी साहिब"),
  CustomModel(title: "ਅਨੰਦੁ ਸਾਹਿਬ", subTitle: "अनंदु साहिब"),
  CustomModel(title: "ਰਹਿਰਾਸ ਸਾਹਿਬ", subTitle: "रहरासि साहिब"),
  CustomModel(title: "ਸੋਹਿਲਾ", subTitle: "सोहिला"),
  CustomModel(title: "ਸ਼ਬਦ ਹਜ਼ਾਰੇ", subTitle: "शबद हज़ारे"),
  CustomModel(title: "ਸਲੋਕ ਮਹਲਾ ੯", subTitle: "सलोक महला ९"),
  CustomModel(title: "ਦੁਖ ਭੰਜਨੀ ਸਾਹਿਬ", subTitle: "दुख भंजनी साहिब"),
  CustomModel(title: "ਅਰਦਾਸਿ", subTitle: "अरदास"),
];

List<CustomModel> amritvelaWakeUpCallScreenList = [
  CustomModel(
      title: "ITEM 1",
      subTitle: "ITEM 1",
      description:
          "INSIDE THERE ARE ANOTHER LIST VIEW ON CLICK OF THAT WE WILL DISPLAY DATA "),
  CustomModel(
      title: "ITEM 2",
      subTitle: "ITEM 2",
      description: "MAIN DATA JAISE AB DISPLAY KAR REHE HAI PART 1 "),
  CustomModel(
      title: "ITEM 3",
      subTitle: "ITEM 3 ",
      description: "MAIN DATA JAISE AB DISPLAY KAR REHE HAI PART 2"),
  CustomModel(
      title: "SEARCHING UI ",
      subTitle: "ITEM 4",
      description: "SEARCHING THE THINGS FROM DB"),
];
