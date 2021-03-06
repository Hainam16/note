import 'package:intl/intl.dart';
import 'package:note/databases/models_store.dart';
import 'package:note/import.dart';

enum TypeCalendar { calendar, timeline }

class Controller extends GetxController {
  final List<Models> items;
  Controller(this.items);

  final eventController = TextEditingController().obs;
  RxString startTime = DateFormat('HH:mm a').format(DateTime.now()).obs;
  final date = DateTime.now().obs;
  final focusedDayController = DateTime.now().obs;
  RxList<Models?> listEvent = <Models>[].obs;
  final format = CalendarFormat.month.obs;

  final ModelsStore mod = ModelsStore();
  late Map<String, List<Models>> selectedModels;

  late ValueNotifier<TypeCalendar> switchTimelime;

  var validate = false.obs;


  @override
  void onInit() {
    getAll();
    super.onInit();
  }

  getAll() {
    selectedModels = {};
    for (var element in items) {
      if (selectedModels.containsKey(element.day)) {
        selectedModels.update(element.day, (value) => value..add(element));
      } else {
        selectedModels.putIfAbsent(element.day, () => [element]);
      }
    }
    update();
  }
}
