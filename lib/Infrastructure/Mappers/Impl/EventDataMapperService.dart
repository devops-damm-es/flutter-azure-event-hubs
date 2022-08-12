import 'package:flutter/foundation.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventData.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/IEventDataMapperService.dart';
import '../../../Crosscutting/JsonMapperService.dart';

class EventDataMapperService extends IEventDataMapperService {
  @override
  Future<EventData> fromJson(String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecode, jsonString);
    var map = Map<String, dynamic>.from(result);
    return fromMap(map);
  }

  @override
  Future<EventData> fromMap(Map<String, dynamic> map) async {
    var result = new EventData(map["body"]);
    return Future.value(result);
  }

  @override
  Future<Iterable<EventData>> fromJsonList(String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecodeList, jsonString);
    var mappedResult = List<Map<String, dynamic>>.from(result);

    var returnList = new List<EventData>.empty(growable: true);
    for (var i = 0; i < mappedResult.length; i++) {
      var map = mappedResult[i];
      var eventData = await fromMap(map);
      returnList.add(eventData);
    }
    return Future.value(returnList);
  }

  @override
  Future<String> toJson(EventData eventData) async {
    var map = await toMap(eventData);
    return compute(JsonMapperService.jsonEncode, map);
  }

  @override
  Future<String> toJsonFromList(Iterable<EventData> eventDataList) async {
    var mapList = new List<Map<String, dynamic>>.empty(growable: true);
    for (var i = 0; i < eventDataList.length; i++) {
      var map = await toMap(eventDataList.elementAt(i));
      mapList.add(map);
    }
    return compute(JsonMapperService.jsonEncodeList, mapList);
  }

  @override
  Future<Map<String, dynamic>> toMap(EventData eventData) async {
    var map = new Map<String, dynamic>();
    map["body"] = eventData.body;
    return Future.value(map);
  }
}
