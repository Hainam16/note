import 'package:intl/intl.dart';
import 'package:note/databases/models_store.dart';
import 'package:note/import.dart';
import 'package:timelines/timelines.dart';

class TimeLine extends StatefulWidget {
  final ValueChanged? onChanged;

  const TimeLine({Key? key, this.onChanged}) : super(key: key);

  @override
  State<TimeLine> createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  var format = DateFormat('dd/MM/yyyy');
  late Map<String, List<Models>> selectedModels;
  DateTime selectedDay = DateTime.now();
  Controller controller = Get.put(Controller());
  final ModelsStore m = ModelsStore();

  @override
  void initState() {
    selectedModels = {};
    Future.delayed(700.milliseconds, () {
      m.findAll().then((value) {

        value.sort((a, b) {
          DateTime t1 = DateFormat('dd/MM/yyyy').parse(a.day);
          DateTime t2 = DateFormat('dd/MM/yyyy').parse(b.day);
          return t1.compareTo(t2);
        });
        controller.listEvent.value = value;
        setState(() {});
      });
    });
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
              const SizedBox(height: 20),
              MyButton(
                label: 'Calendar',
                onTap: () {
                  Get.back();
                },
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 50),
              FixedTimeline.tileBuilder(
                builder: TimelineTileBuilder.connectedFromStyle(
                  contentsAlign: ContentsAlign.reverse,
                  oppositeContentsBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${controller.listEvent[index]?.title}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 15),
                            maxLines: 1,
                          ),
                        ),
                        Text('${controller.listEvent[index]?.hour}'),
                      ],
                    ),
                  ),
                  contentsBuilder: (context, index) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${controller.listEvent[index]?.day}'
                          .substring(0, 10)),
                    ),
                  ),
                  connectorStyleBuilder: (context, index) =>
                      ConnectorStyle.solidLine,
                  indicatorStyleBuilder: (context, index) =>
                      IndicatorStyle.outlined,
                  itemCount: controller.listEvent.length,
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
                          Text(
                            controller.date.value.toString().substring(0, 10),
                          ),
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
                        Models models = Models(
                            title: controller.eventController.value.text,
                            hour: controller.startTime.value,
                            day: format
                                .format(controller.date.value));
                        controller.listEvent.add(models);

                        if (selectedModels
                            .containsKey(format.format(selectedDay))) {
                          selectedModels.update(format.format(selectedDay),
                                  (value) => value..add(models));
                        } else {
                          selectedModels.putIfAbsent(
                              format.format(selectedDay),
                                  () => [
                                models,
                              ]);
                        }
                        m.save(models);
                        Get.back();
                        controller.eventController.value.clear();
                        controller.startTime.value;

                        if(widget.onChanged != null) widget.onChanged!(selectedModels);
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
    } else {}
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
    } else {}
  }
}
