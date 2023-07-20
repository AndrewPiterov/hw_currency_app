import 'package:currency_app/app/app.dart';
import 'package:get/get.dart';

class SettingsPageController extends GetxController {
  final AppRouter _router = Get.find();

  Future save() async {
// TODO:

    await _router.pop();
  }
}
