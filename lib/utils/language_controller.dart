import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  final RxBool _isEnglish = true.obs;

  bool get isEnglish => _isEnglish.value;

  LanguageController.fromHome(bool initialIsEnglish) {
    _isEnglish.value = initialIsEnglish;
  }
  LanguageController();

  void toggleLanguage() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    _isEnglish.toggle();
    sharedPreferences.setBool('isEnglish', _isEnglish.value);
    // You can also store the updated language preference in shared preferences or any other storage mechanism here
  }
}
