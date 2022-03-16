import 'package:intl/intl.dart';
import 'package:note/import.dart';

class Controller extends GetxController{
  final eventController = TextEditingController().obs;
  RxString startTime = DateFormat('hh:mm a').format(DateTime.now()).obs;
  final date = DateTime.now().obs;
  final focusedDayController = DateTime.now().obs;
  RxList<Models?> listEvent = <Models>[].obs;
  final format = CalendarFormat.month.obs;

}