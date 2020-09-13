import 'package:get/get.dart';

class GroupMembersAdd extends GetxController {
  List members = [].obs;

  void add(String memberId) {
    members.add(memberId);
    update();
  }

  void remove(String memberId) {
    members.remove(memberId);
    update();
  }
}
