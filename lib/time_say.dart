import 'package:flutter/material.dart';

class Timecall extends StatefulWidget {

  const Timecall({Key? key}) : super(key: key);

  @override
  State<Timecall> createState() => _TimecallState();
}

class _TimecallState extends State<Timecall> {
  String text = "";

  int nowtime = DateTime.now().hour;

  String timeCall() {
    if (nowtime <= 11) {
      text = "  Chào buổi sáng  ☀️";
    }
    if (nowtime > 11) {
      text = "  Chào buổi chiều  🌞";
    } if (nowtime >= 18){
      text = "  Chào buổi tối  🌆";
    } if (nowtime >= 22) {
      text = "  Ngủ ngon  🌙";
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      timeCall(),
      style: const TextStyle(
        fontSize: 20
      ),
    );
  }
}
