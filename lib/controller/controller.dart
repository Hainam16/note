import 'package:intl/intl.dart';
import 'package:note/import.dart';

class Controller extends GetxController{
  final eventController = TextEditingController().obs;
  RxString startTime = DateFormat('hh:mm a').format(DateTime.now()).obs;
  final focusedDayController = DateTime.now().obs;
  RxList<Models?> listEvent = <Models>[].obs;
  RxList<Models?> listDay = <Models>[].obs;
  final format = CalendarFormat.month.obs;

}