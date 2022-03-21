import 'package:intl/intl.dart';
import 'package:note/databases/models_store.dart';
import 'package:note/import.dart';

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
  final controller = Get.find<Controller>();
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
                  Get.back(result: selectedModels);
                },
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: controller.listEvent
                    .map<Widget>((element) => TimelineTile(
                          alignment: TimelineAlign.manual,
                          lineXY: 0.3,
                          beforeLineStyle:
                              const LineStyle(color: Colors.grey, thickness: 1),
                          indicatorStyle: const IndicatorStyle(
                            width: 10,
                          ),
                          endChild: ListTile(
                            onTap: () => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                    title: const Align(child: Text('Chi tiết')),
                                    content: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: Text('${element?.title}',
                                              textAlign: TextAlign.center),
                                        )
                                      ],
                                    ))),
                            title: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${element?.title}',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 15),
                                        maxLines: 1,
                                      ),
                                    ),
                                    Text('${element?.hour}'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          startChild: Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${element?.day}'.substring(0, 10),
                                ),
                                Text(
                                  getWeekday(DateFormat('dd/MM/yyyy')
                                          .parse(element!.day)
                                          .weekday +
                                      1),
                                  style: Theme.of(context).textTheme.subtitle2,
                                )
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink,
          child: const Icon(Icons.add),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => Obx(() => AlertDialog(
                  title: const Align(child: Text('Thêm ghi chú')),
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
                          const Text('Nhập giờ'),
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
                      child: const Text('Cancel'),
                      onPressed: () => Get.back(),
                    ),
                    TextButton(
                      child: const Text("Ok"),
                      onPressed: () async {
                        if (controller.eventController.value.text.isEmpty) {
                        } else {
                          Models models = Models(
                              title: controller.eventController.value.text,
                              hour: controller.startTime.value,
                              day: format.format(controller.date.value));
                          controller.listEvent.add(models);

                          if (selectedModels
                              .containsKey(format.format(selectedDay))) {
                            selectedModels.update(format.format(selectedDay),
                                (value) => value..add(models));
                          } else {
                            selectedModels.putIfAbsent(
                                format.format(selectedDay), () => [models]);
                          }

                          EasyLoading.show();
                          await m.save(models);
                          EasyLoading.dismiss();

                          if (widget.onChanged != null) {
                            widget.onChanged!(selectedModels);
                          }
                          EasyLoading.showSuccess('Thêm mới thành công');
                        }
                        controller.update();
                        Get.back(result: selectedModels);
                        controller.eventController.value.clear();
                        setState(() {});
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
  String getWeekday(int weekday) {
    switch (weekday) {
      case 8:
        return 'Chủ nhật';
      default:
        return 'Thứ $weekday';
    }
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