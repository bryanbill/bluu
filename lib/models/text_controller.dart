import 'package:get/get.dart';

class TextCountController extends GetxController {
  RxInt count = 0.obs;
  RxInt desc = 0.obs;
  increment(String value) {
    count = RxInt(value != null ? value.length: 0);
    update();
  }

  descInc(String value) {
    desc = RxInt(value != null ? value.length: 0);
    update();
  }
}
