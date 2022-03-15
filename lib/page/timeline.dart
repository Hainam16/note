import 'package:note/import.dart';
import 'package:timelines/timelines.dart';
class TimeLine extends StatelessWidget {
  const TimeLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Controller controller =Get.put(Controller());
    return SafeArea(
      child: Scaffold(
          body: Obx(()=>SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                MyButton(label: 'Calendar', onTap:(){Get.back();}, color: Colors.blueAccent, ),
                TimelineTile(
                  mainAxisExtent:150,
                  nodePosition: 0.2,
                  oppositeContents:  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      controller.listEvent.value[0]!.day.toString().substring(5,10),
                      style: const TextStyle(color: Colors.black),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                   e!.title,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.white,fontSize: 15),
                                    maxLines: 1,
                                  ),
                                ),
                                Text(
                                  e.hour,
                                  style: const TextStyle(color: Colors.white,fontSize: 15),
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
          ))
        ),
    );
  }
}
