import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/controller/controller.dart';
import 'package:note/model/models.dart';
import 'package:table_calendar/table_calendar.dart';

import 'timeline.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late Map<DateTime, List<Models>> selectedModels;
  DateTime selectedDay = DateTime.now();

  @override
  void initState() {
    selectedModels = {};
    super.initState();
  }

  List<Models> getEventsfromDay(DateTime date) {
    return selectedModels[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    Controller controller =Get.put(Controller());
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
            child: Column(
              children: [
                TableCalendar(
                  focusedDay: selectedDay,
                  firstDay: DateTime(2010),
                  lastDay: DateTime(2050),
                  calendarFormat: controller.format.value,
                  onFormatChanged: (CalendarFormat _format) {
                  },
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  daysOfWeekVisible: true,

                  //Day Changed
                  onDaySelected: (DateTime selectDay, DateTime focusDay) {
                    setState(() {
                      selectedDay = selectDay;
                      controller.focusedDayController.value = focusDay;
                    });
                  },
                  selectedDayPredicate: (DateTime date) {
                    return isSameDay(selectedDay, date);
                  },

                  eventLoader: getEventsfromDay,

                  //To style the Calendar
                  calendarStyle: const CalendarStyle(
                    isTodayHighlighted: true,
                    selectedDecoration: BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: TextStyle(color: Colors.white),
                    todayDecoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle
                    ),
                    defaultDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    formatButtonShowsNext: false,
                  ),
                ),
                ElevatedButton(
                    onPressed: (){
                      Get.to(const TimeLine());},
                    child: const Text('TimeLine')
                ),
                ...getEventsfromDay(selectedDay).map(
                      (Models model) => ListTile(
                    title: SizedBox(
                      height: 50,
                      child: Container(
                        padding: const EdgeInsets.only(left: 20,right: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.blue,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                model.title,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white),
                                maxLines: 1,
                              ),
                            ),
                            Text(
                              model.hour,
                              style: const TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink,
          child: const Icon(Icons.add),
          onPressed: () => showDialog(
            context: context,
            builder: (context) =>Obx(()=> AlertDialog(
              title: const Text("Add Event"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Nhập ghi chú',
                    ),
                    controller: controller.eventController.value,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration:const InputDecoration(
                      hintText: 'Nhập giờ'
                    ),
                    controller: controller.eventTimeController.value,
                  )
                ],
              ),
              actions: [
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () => Get.back(),
                ),
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    if (controller.eventController.value.text.isEmpty && controller.eventTimeController.value.text.isEmpty) {
                    } else {
                      controller.listEvent.add(
                        Models(title: controller.eventController.value.text,
                            hour:controller.eventTimeController.value.text,
                            day: controller.focusedDayController.value),
                      );
                      if (selectedModels[selectedDay] != null) {
                        selectedModels[selectedDay]!.add(
                          Models(title: controller.eventController.value.text,
                          hour:controller.eventTimeController.value.text,
                          day: controller.focusedDayController.value),
                        );
                      } else {
                        selectedModels[selectedDay] = [
                          Models(title: controller.eventController.value.text,
                          hour: controller.eventTimeController.value.text,
                          day: controller.focusedDayController.value),
                        ];
                      }
                    }
                    Get.back();
                    controller.eventController.value.clear();
                    controller.eventTimeController.value.clear();
                    setState(() {
                    });
                    return;
                  },
                ),
              ],
            )),
          ),
        ),
        floatingActionButtonLocation:FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}