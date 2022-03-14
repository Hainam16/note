import 'package:flutter/material.dart';
import 'package:note/controller/controller.dart';
import 'package:timelines/timelines.dart';
import 'package:get/get.dart';


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
                ElevatedButton(onPressed: (){
                  Get.back();
                }, child: const Text('Calendar')),
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
                                Text(
                                 e!.title.toString(),
                                  style: const TextStyle(color: Colors.white,fontSize: 15),
                                ),
                                Text(
                                  e.hour.toString(),
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
