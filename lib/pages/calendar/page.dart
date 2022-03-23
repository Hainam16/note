import 'package:intl/intl.dart';
import 'package:note/common/theme_service.dart';
import 'package:note/import.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:note/common/time_call.dart';
import 'package:note/theme.dart';

enum TypeCalendar { calendar, timeline }

class CalendarPage extends StatefulWidget {
  final List<Models> items;

  const CalendarPage({Key? key, required this.items}) : super(key: key);

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

  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    isDark = Get.isDarkMode;
    return GetBuilder<Controller>(
        init: Controller(widget.items.isNotEmpty ? widget.items : []),
        builder: (controller) {
          return SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.drag_handle_outlined,
                            color: Colors.grey,
                            size: 35,
                          ),
                          onPressed: () async {
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
                        ),
                        Timecall(isDark),
                        IconButton(
                          onPressed: () {
                            ThemeServices.switchTheme();
                          },
                          icon: Icon(
                            Get.isDarkMode
                                ? Icons.wb_sunny_outlined
                                : Icons.nightlight_round_outlined,
                            size: 24,
                            color: Get.isDarkMode ? Colors.white : darkGreyClr,
                          ),
                        ),
                      ],
                    ),
                    TableCalendar(
                      focusedDay: selectedDay,
                      firstDay: DateTime(2015),
                      lastDay: DateTime(2050),
                      locale: 'vi_VN',
                      calendarFormat: controller.format.value,
                      onFormatChanged: (CalendarFormat _format) {},
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      daysOfWeekVisible: true,
                      daysOfWeekHeight: 50,
                      daysOfWeekStyle:const DaysOfWeekStyle(
                          decoration: BoxDecoration(color: Colors.white)),
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
                        markerDecoration: BoxDecoration(
                          color: Colors.yellow,
                          shape: BoxShape.circle,
                        ),
                        isTodayHighlighted: true,
                        selectedDecoration: BoxDecoration(
                          color: Colors.orangeAccent,
                          shape: BoxShape.circle,
                        ),
                        selectedTextStyle: TextStyle(color: Colors.white),
                        todayDecoration: BoxDecoration(
                            color: Colors.pink, shape: BoxShape.circle),
                        defaultDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                      ),
                      headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          formatButtonShowsNext: false,
                          titleTextFormatter: (date, style) {
                            return DateFormat.yMMMM('vi_VN')
                                .format(date)
                                .toUpperCase();
                          }),
                    ),
                    const SizedBox(height: 20),
                    ...getEventsfromDay(selectedDay)
                        .map((Models model) => Container(
                              margin: const EdgeInsets.only(bottom: 10)
                                  .copyWith(left: 10, right: 10),
                              child: Slidable(
                                endActionPane: ActionPane(
                                  motion: const StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      icon: Icons.edit,
                                      label: 'Sửa',
                                      onPressed: (BuildContext context) {
                                        _editForm(model: model);
                                      },
                                    ),
                                    SlidableAction(
                                      backgroundColor: const Color(0xFFFE4A49),
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Xóa',
                                      onPressed: (BuildContext context) {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: const Align(
                                                      child:
                                                          Text('Xóa ghi chú')),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        child: const Text(
                                                            'Cancel')),
                                                    TextButton(
                                                      child: const Text('Ok'),
                                                      onPressed: () async {
                                                        if (controller.selectedModels.containsKey(
                                                                format.format(selectedDay))) {
                                                          controller.selectedModels[
                                                                  format.format(selectedDay)]
                                                              ?.remove(model);
                                                        }
                                                        EasyLoading.show();
                                                        await Future.delayed(200.milliseconds);
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
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Theme.of(context).floatingActionButtonTheme.backgroundColor),
                                  child: ListTile(
                                    onTap: () => showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: const Text('Đóng')),
                                        ],
                                        title: const Align(
                                            child: Text('Chi tiết')),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              model.title,
                                              textAlign: TextAlign.center,
                                              // style: titleStyle,
                                            ),
                                            const SizedBox(height: 20),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(Icons.access_time, color: Colors.red,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Flexible(
                                                      child: Text(
                                                        model.hour,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.calendar_today_rounded,
                                                      color: Colors.red,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Flexible(
                                                        child: Text(
                                                      model.day,
                                                      textAlign: TextAlign.center,
                                                    )),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    title: Container(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              model.title,
                                              overflow: TextOverflow.ellipsis,
                                              style: titleStyle,
                                              maxLines: 1,
                                            ),
                                          ),
                                          Text(
                                            model.hour,
                                            style: hourStyle,
                                          ),
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
                child: const Icon(Icons.add, color: Colors.white,),
                onPressed: () {
                  controller.validate.value = false;
                  _editForm(model: Models(title: '', hour: '', day: ''));
                },
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
    controller.startTime.value = model.hour.trim().isNotEmpty
        ? model.hour
        : DateFormat('HH:mm a').format(DateTime.now());
    return showDialog(
      context: context,
      builder: (context) => Obx(() => SingleChildScrollView(
            child: AlertDialog(
              title: Align(
                  child: Text('${key != null ? 'Chỉnh sửa' : 'Thêm'} ghi chú')),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() => TextFormField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Nhập ghi chú',
                          errorText: controller.validate.value
                              ? 'Chưa nhập ghi chú!'
                              : null,
                        ),
                        controller: controller.eventController.value,
                      )),
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
                  onPressed: () {
                    controller.validate.value = false;
                    Get.back();
                  },
                ),
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () async {
                    setState(() {
                      controller.eventController.value.text.isEmpty
                          ? controller.validate.value = true
                          : controller.validate.value = false;
                    });
                    if (!controller.validate.value) {
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
                          controller.selectedModels.putIfAbsent(element.day, () => [element]);
                        }
                      }
                      Get.back();
                      controller.eventController.value.clear();
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
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
