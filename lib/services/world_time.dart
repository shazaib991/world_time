import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  String? location;
  String? time;
  String? flag;
  String? url;
  bool? isDayTime = true;

  WorldTime({this.location, this.flag, this.url});

  Future<void> getData() async {
    try {
      var uri = Uri.parse("http://worldtimeapi.org/api/timezone/$url");

      Response response = await get(uri);
      Map data = jsonDecode(response.body);

      String dateTime = data["datetime"];
      String offSet = data["utc_offset"].substring(0, 3);

      DateTime now = DateTime.parse(dateTime);
      if (int.parse(offSet) > 0) {
        now = now.add(Duration(hours: int.parse(offSet)));
      } else {
        offSet = offSet.substring(1, 3);
        now = now.subtract(Duration(hours: int.parse(offSet)));
      }
      isDayTime = now.hour > 6 && now.hour < 20 ? true : false;
      time = DateFormat.jm().format(now);
    } catch (e) {
      time = "could not get time";
    }
  }
}
