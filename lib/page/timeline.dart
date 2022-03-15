import 'package:note/import.dart';
import 'package:timelines/timelines.dart';

class TimeLine extends StatefulWidget {
  const TimeLine({Key? key}) : super(key: key);

  @override
  State<TimeLine> createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
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
    Controller controller = Get.put(Controller());
    return SafeArea(
      child: Scaffold(
          body: Obx(() => SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    MyButton(
                      label: 'Calendar',
                      onTap: () {
                        Get.back();
                      },
                      color: Colors.blueAccent,
                    ),
                    TimelineTile(
                      mainAxisExtent: 150,
                      nodePosition: 0.2,
                      oppositeContents: SingleChildScrollView(
                        child: Column(
                          children: controller.listEvent.value.map((e) {
                            return Text(
                              e!.day.toString().substring(0, 10),
                              style: const TextStyle(color: Colors.black),
                              textAlign: TextAlign.center,
                            );
                          }).toList(),
                        ),
                      ),
                      contents: SingleChildScrollView(
                        child: Column(
                          children: controller.listEvent.value.map((e) {
                            return Card(
                              child: Container(
                                color: Colors.blue,
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        e!.title,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 15),
                                        maxLines: 1,
                                      ),
                                    ),
                                    Text(
                                      e.hour,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      node: const TimelineNode(
                        indicator: DotIndicator(),
                        startConnector: SolidLineConnector(),
                        endConnector: SolidLineConnector(),
                      ),
                    ),
                  ],
                ),
              )
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
                          getTime(isStartTime: true);
                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Chọn ngày'),
                      Text(controller.date.value.toString().substring(0, 10),),
                      IconButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          getDate();
                        },
                        icon: const Icon(
                          Icons.calendar_today_outlined,
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
                            day: controller.date.value),
                      );
                      if (selectedModels[selectedDay] != null) {
                        selectedModels[selectedDay]!.add(
                          Models(
                              title: controller.eventController.value.text,
                              hour: controller.startTime.value,
                              day: controller.date.value),
                        );
                      } else {
                        selectedModels[selectedDay] = [
                          Models(
                              title: controller.eventController.value.text,
                              hour: controller.startTime.value,
                              day: controller.date.value),
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
  getTime({required bool isStartTime}) async {
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
  getDate() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (_pickedDate != null) {
      setState(() => controller.date.value = _pickedDate);
    } else{}
  }
}
