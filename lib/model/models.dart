import 'package:sembast/sembast.dart';

class Models {
  int? key;

  final String title;
  final String hour;
  final String day;
  final int? id;

  Models(
      {this.key, required this.title, required this.hour, required this.day, this.id});

  Models.fromJson(Map<String, dynamic> json)
      : title = json['title'] as String,
        hour = json['hour'] as String,
        day = json['day'] as String,
        id = json['id'] as int;

  Map<String, dynamic> toJson() => {
        'title': title,
        'hour': hour,
        'day': day,
      };

  Models.fromDatabase(RecordSnapshot<int, Map<String, dynamic>> snapshot)
      : title = snapshot.value['title'] as String,
        hour = snapshot.value['hour'] as String,
        id = snapshot.value['id'] != null ? snapshot.value['id'] as int : null,
        day = (snapshot.value['day'] != null) ?snapshot.value['day'].toString() : '',
        key = snapshot.key;

}
