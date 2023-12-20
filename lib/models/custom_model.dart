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
      title: "Nitnem",
      subTitle: "Nitnem",
      description:
      "INSIDE THERE ARE ANOTHER LIST VIEW Nitnem ON CLICK OF THAT WE WILL DISPLAY DATA "),
  CustomModel(
      title: "Book One",
      subTitle: "Book One",
      description: "MAIN DATA For Book One "),
  CustomModel(
      title: "Book Two",
      subTitle: "Book Two",
      description: "MAIN DATA JFor Book Two"),
  CustomModel(
      title: "SEARCHING UI ",
      subTitle: "Go to Search",
      description: "SEARCHING THE THINGS FROM DB"),
];