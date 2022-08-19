import 'package:date_time_format/date_time_format.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/IDateTimeMapperService.dart';

class DateTimeMapperService extends IDateTimeMapperService {
  @override
  Future<String> toStringDateTimeUtc(DateTime dateTime) async {
    var stringDateTime =
        DateTimeFormat.format(dateTime, format: r"Y-m-d\TH:i:s.v\Z");
    if (dateTime.millisecond.toString().length == 1 &&
        dateTime.millisecond > 0) {
      stringDateTime += ".00" + dateTime.millisecond.toString();
    } else if (dateTime.millisecond.toString().length == 2) {
      var twoMilliseconds = ".0" + dateTime.millisecond.toString();
      if (twoMilliseconds.endsWith("0")) {
        twoMilliseconds =
            twoMilliseconds.substring(0, twoMilliseconds.length - 1);
      }
      stringDateTime += twoMilliseconds;
    } else if (dateTime.millisecond.toString().length == 3) {
      var threeMilliseconds = "." + dateTime.millisecond.toString();
      if (threeMilliseconds.endsWith("00")) {
        threeMilliseconds =
            threeMilliseconds.substring(0, threeMilliseconds.length - 2);
      } else if (threeMilliseconds.endsWith("0")) {
        threeMilliseconds =
            threeMilliseconds.substring(0, threeMilliseconds.length - 1);
      }
      stringDateTime += threeMilliseconds;
    }
    return Future.value(stringDateTime);
  }

  @override
  Future<DateTime> toDateTimeUtc(String stringDateTime) async {
    var dateTime = DateTime.parse(stringDateTime.split(".")[0] + 'Z');
    if (stringDateTime.split(".").length > 1) {
      var milliseconds = stringDateTime.split(".")[1].split("Z")[0];
      if (milliseconds.length == 1) {
        milliseconds += "00";
      } else if (milliseconds.length == 2) {
        milliseconds += "0";
      }
      dateTime =
          dateTime.add(new Duration(milliseconds: int.parse(milliseconds)));
    }
    return Future.value(dateTime);
  }
}
