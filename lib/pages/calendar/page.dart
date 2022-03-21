import 'package:intl/intl.dart';
import 'package:note/import.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

enum TypeCalendar { calendar, timeline }

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime selectedDay = DateTime.now();
  late ValueNotifier<TypeCalendar> switchTimelime;

  var format = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    switchTimelime = ValueNotifier(TypeCalendar.calendar);

    super.initState();
  }

  List<Models> getEventsfromDay(DateTime date) {
    final controller = Get.find<Controller>();
    return controller.selectedModels[format.format(date)] ?? [];
  }

  @override
  void didUpdateWidget(covariant CalendarPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Controller>(
        init: Controller(),
        builder: (controller) {
          return SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    MyButton(
                      label: const Text(
                        'Timeline',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () async {
                        await Get.to(TimeLine(
                          onChanged: (val) {
                            val.forEach((k, v) {
                              if (controller.selectedModels.containsKey(k)) {
                                controller.selectedModels.update(k, (value) => [...value, ...v]);
                              } else {
                                controller.selectedModels.putIfAbsent(k, () => v);
                              }
                            });
                            controller.update();
                          },
                        ));
                        controller.update();
                        setState(() {});
                      },
                      color: Colors.blueAccent,
                    ),
                    TableCalendar(
                      focusedDay: selectedDay,
                      firstDay: DateTime(2015),
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
                    const SizedBox(height: 20),
                    ...getEventsfromDay(selectedDay)
                        .map((Models model) => Container(
                              margin: const EdgeInsets.only(bottom: 10)
                                  .copyWith(left: 10, right: 10),
                              child: Slidable(
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      icon: Icons.edit,
                                      label: 'Edit',
                                      onPressed: (BuildContext context) {
                                        _editForm(model: model);
                                      },
                                    ),
                                    SlidableAction(
                                      backgroundColor: const Color(0xFFFE4A49),
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                      onPressed: (BuildContext context) {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: const Align(
                                                      child: Text('Xóa ghi chú')),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        child: const Text('Cancel')),
                                                    TextButton(
                                                      child: const Text('Ok'),
                                                      onPressed: () async {
                                                        if (controller.selectedModels.containsKey(
                                                                format.format(selectedDay))) {
                                                          controller.selectedModels[format.format(selectedDay)]?.remove(model);
                                                        }
                                                        EasyLoading.show();
                                                        await Future.delayed(400.milliseconds);
                                                        await controller.mod.delete(model);
                                                        EasyLoading.dismiss();
                                                        EasyLoading.showToast('Xóa thành công',
                                                            toastPosition: EasyLoadingToastPosition.bottom);
                                                        Navigator.of(context, rootNavigator: true).pop();
                                                        setState(() {});
                                                      },
                                                    )
                                                  ],
                                                ));
                                      },
                                    ),
                                  ],
                                ),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(.15),
                                  ),
                                  child: ListTile(
                                    onTap: ()=> showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title:const Align(child:Text('Chi tiết')),
                                          content:Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('Ghi chú: ${model.title}',
                                                    textAlign: TextAlign.center),
                                              const SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text('Thời gian: ${model.hour}',
                                                  textAlign: TextAlign.center,),
                                                  const SizedBox(width: 30),
                                                  Text('Ngày: ${model.day}',
                                                  textAlign: TextAlign.center,),
                                                ],
                                              )
                                            ],
                                          )
                                        )),
                                    title: Container(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              model.title,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                          Text(
                                            model.hour,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.pink,
                child: const Icon(Icons.add),
                onPressed: () => _editForm(model: Models(title: '', hour: '', day: '')),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            ),
          );
        });
  }

  _editForm({required Models model}) {
    final controller = Get.find<Controller>();

    String title = model.title;
    int? key = model.key;

    String hour = model.hour;
    RegExp regExp = RegExp(r'[(AP)M]');
    if (regExp.hasMatch(hour)) {
      hour = hour.replaceAll(regExp, '');
    }

    String _time = '';
    _time = model.day + ' ' + hour;

    controller.eventController.value.text = title;
    controller.startTime.value = model.hour.trim().isNotEmpty ? model.hour
        : DateFormat('HH:mm a').format(DateTime.now());
    return showDialog(
      context: context,
      builder: (context) => Obx(() => AlertDialog(
            title: Align(
                child: Text('${key != null ? 'Chỉnh sửa' : 'Thêm'} ghi chú')),
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
                    const Text('chọn giờ'),
                    Text(controller.startTime.value),
                    IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        getTimeFromUser(
                          isStartTime: true,
                          time: _time.isNotEmpty ? _time : null,
                        );
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
                onPressed: () async {
                  if (controller.eventController.value.text.isEmpty) {
                  } else {
                    Models models = Models(
                      key: key,
                      title: controller.eventController.value.text,
                      hour: controller.startTime.value,
                      day: format.format(controller.focusedDayController.value),
                    );
                    controller.listEvent.add(models);
                    List<Models> result = [];
                    if (key != null) {
                      await controller.mod.update(models);
                      result = await controller.mod.findAll();
                      EasyLoading.showSuccess('Chỉnh sửa thành công');
                    } else {
                      result = await controller.mod.save(models);
                      EasyLoading.showSuccess('Thêm mới thành công');
                    }
                    controller.selectedModels = {};
                    for (var element in result) {
                      if (controller.selectedModels.containsKey(element.day)) {
                        controller.selectedModels.update(
                            element.day, (value) => value..add(element));
                      } else {
                        controller.selectedModels
                            .putIfAbsent(element.day, () => [element]);
                      }
                    }
                  }

                  Get.back();
                  controller.eventController.value.clear();
                  setState(() {});
                },
              ),
            ],
          )),
    );
  }

  getTimeFromUser({required bool isStartTime, String? time}) async {
    final controller = Get.find<Controller>();
    DateTime? _t;
    time = time?.trim();
    if (time != null && time.isNotEmpty) {
      _t = DateFormat('dd/MM/yyyy HH:mm').parse(time);
    }
    TimeOfDay? _pickedTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay.fromDateTime(_t ?? DateTime.now()),
    );
    String _formattedTime = _pickedTime!.format(context);
    if (isStartTime) {
      setState(() => controller.startTime.value = _formattedTime);
    } else {}
  }
}