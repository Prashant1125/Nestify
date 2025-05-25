import 'package:get/get.dart';

class MembershipTypeRadioController extends GetxController {
  RxInt currentIndex = 100.obs;

  RxString selectedItem = "".obs;
  //initially index to be 100 meaning no radio is selected

  void updateIndex(int index, String selected) {
    currentIndex.value = index;
    selectedItem.value = selected;
    // print('************************************');
    // print(currentIndex.value);
    // print(Selected.value); // TO BE PASSED IN THE API
  }
}
