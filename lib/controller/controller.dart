import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:note/model/models.dart';
import 'package:table_calendar/table_calendar.dart';

class Controller extends GetxController{
  final eventController = TextEditingController().obs;
  final eventTimeController = TextEditingController().obs;
  final focusedDayController = DateTime.now().obs;
  RxList<Models?> listEvent = <Models>[].obs;
  RxList<Models> listDay = <Models>[].obs;
  final format = CalendarFormat.month.obs;

}