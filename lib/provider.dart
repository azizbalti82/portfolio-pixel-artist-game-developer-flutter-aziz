import 'package:get/get.dart';

class Provider extends GetxController {
  RxInt currentIndex = 0.obs;
  RxBool isDark = false.obs;

  void setCurrentIndex(int index) {
    currentIndex.value = index;
  }
  void setIsDark(bool value) {
    isDark.value = value;
  }
}
