import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:note/model/models.dart';
import 'package:note/pages/calendar/page.dart';
import 'databases/models_store.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark));
  final ModelsStore model = ModelsStore();
  final res = await model.findAll();
  initializeDateFormatting('vi_VN', null);
  return runApp(MyApp(items: res));
}

// const AndroidInitializationSettings initializationSettingsAndroid =
// AndroidInitializationSettings('app_icon');
// void selectNotification(String payload) async {
//   if (payload != null) {
//     debugPrint('notification payload: $payload');
//   }
//   await Get.to(CalendarPage);
// }
class MyApp extends StatelessWidget {
  final List<Models> items;

  const MyApp({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeMode.system,
      home: CalendarPage(items: items),
      builder: EasyLoading.init(),
    );
  }
}
