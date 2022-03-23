import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Timecall extends StatefulWidget {
  final bool isDark;

  const Timecall(this.isDark, {Key? key}) : super(key: key);

  @override
  State<Timecall> createState() => _TimecallState();
}

class _TimecallState extends State<Timecall> {
  String text = "";

  int nowtime = DateTime.now().hour;

  String timeCall() {
    if (nowtime <= 12) {
      text = "  Chào buổi sáng ☀";
    }
    if (nowtime > 12) {
      text = "  Chào buổi chiều 🌞";
    }
    if (nowtime >= 18) {
      text = "  Chào buổi tối 🌆";
    }
    if (nowtime >= 22) {
      text = "  Ngủ ngon 🌙";
    }

    return text;
  }

  bool dark = false;

  @override
  void initState() {
    dark = widget.isDark;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant Timecall oldWidget) {
    // TODO: implement didUpdateWidget
    if (oldWidget.isDark != dark) {
      dark = widget.isDark;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      timeCall(),
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Get.isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }
}
