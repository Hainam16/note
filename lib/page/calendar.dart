import 'package:note/import.dart';
import 'timeline.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late Map<DateTime, List<Models>> selectedModels;
  DateTime selectedDay = DateTime.now();
  Controller controller = Get.put(Controller());

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
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              TableCalendar(
                focusedDay: selectedDay,
                firstDay: DateTime.now(),
                lastDay: DateTime(2050),
                calendarFormat: controller.format.value,
                onFormatChanged: (CalendarFormat _format) {},
                startingDayOfWeek: StartingDayOfWeek.sunday,
                daysOfWeekVisible: true,

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
                calendarStyle: const CalendarStyle(
                  isTodayHighlighted: true,
                  selectedDecoration: BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(color: Colors.white),
                  todayDecoration: BoxDecoration(
                      color: Colors.pink, shape: BoxShape.circle),
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
              MyButton(
                label: 'Time line',
                onTap: () {
                  Get.to(const TimeLine());
                },
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 20),
              ...getEventsfromDay(selectedDay).map(
                (Models model) => ListTile(
                  title: SizedBox(
                    height: 50,
                    child: Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
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
            builder: (context) => Obx(() => AlertDialog(
                  title: const Align(child: Text("Add Event")),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Nhập ghi chú',
                        ),
                        controller: controller.eventController.value,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Start Time'),
                          Text(controller.startTime.value),
                          IconButton(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  getTimeFromUser(isStartTime: true);
                                },
                                icon: const Icon(
                                  Icons.access_time_rounded,
                                  color: Colors.red,
                                ),
                              ),
                        ],
                      ),
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
                        if (controller.eventController.value.text.isEmpty) {
                        } else {
                          controller.listEvent.add(
                            Models(
                                title: controller.eventController.value.text,
                                hour: controller.startTime.value,
                                day: controller.focusedDayController.value),
                          );
                          if (selectedModels[selectedDay] != null) {
                            selectedModels[selectedDay]!.add(
                              Models(
                                  title: controller.eventController.value.text,
                                  hour: controller.startTime.value,
                                  day: controller.focusedDayController.value),
                            );
                          } else {
                            selectedModels[selectedDay] = [
                              Models(
                                  title: controller.eventController.value.text,
                                  hour:
                                      controller.startTime.value,
                                  day: controller.focusedDayController.value),
                            ];
                          }
                        }
                        Get.back();
                        controller.eventController.value.clear();
                        controller.startTime.value;
                        setState(() {});
                        return;
                      },
                    ),
                  ],
                )),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
  getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
          DateTime.now().add(const Duration(minutes: 15))),
    );
    String _formattedTime = _pickedTime!.format(context);
    if (isStartTime) {
      setState(() => controller.startTime.value = _formattedTime);
    } else {
    }
  }
}