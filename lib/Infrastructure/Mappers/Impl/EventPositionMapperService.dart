import 'package:flutter/foundation.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventPosition.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/IEventPositionMapperService.dart';
import '../../../Crosscutting/JsonMapperService.dart';

class EventPositionMapperService extends IEventPositionMapperService {
  @override
  Future<EventPosition> fromJson(String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecode, jsonString);
    var map = Map<String, dynamic>.from(result);
    return fromMap(map);
  }

  @override
  Future<EventPosition> fromMap(Map<String, dynamic> map) async {
    var result = new EventPosition(map["offset"], map["isInclusive"],
        map["enqueuedOn"], map["sequenceNumber"]);
    return Future.value(result);
  }

  @override
  Future<Iterable<EventPosition>> fromJsonList(String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecodeList, jsonString);
    var mappedResult = List<Map<String, dynamic>>.from(result);

    var returnList = new List<EventPosition>.empty(growable: true);
    for (var i = 0; i < mappedResult.length; i++) {
      var map = mappedResult[i];
      var eventPosition = await fromMap(map);
      returnList.add(eventPosition);
    }
    return Future.value(returnList);
  }

  @override
  Future<String> toJson(EventPosition eventPosition) async {
    var map = await toMap(eventPosition);
    return compute(JsonMapperService.jsonEncode, map);
  }

  @override
  Future<String> toJsonFromList(
      Iterable<EventPosition> eventPositionList) async {
    var mapList = new List<Map<String, dynamic>>.empty(growable: true);
    for (var i = 0; i < eventPositionList.length; i++) {
      var map = await toMap(eventPositionList.elementAt(i));
      mapList.add(map);
    }
    return compute(JsonMapperService.jsonEncodeList, mapList);
  }

  @override
  Future<Map<String, dynamic>> toMap(EventPosition eventPosition) async {
    var map = new Map<String, dynamic>();
    if (eventPosition.offset != null) {
      map["offset"] = eventPosition.offset;
    }
    if (eventPosition.isInclusive != null) {
      map["isInclusive"] = eventPosition.isInclusive;
    }
    if (eventPosition.enqueuedOn != null) {
      map["enqueuedOn"] = eventPosition.enqueuedOn;
    }
    if (eventPosition.sequenceNumber != null) {
      map["sequenceNumber"] = eventPosition.sequenceNumber;
    }
    return Future.value(map);
  }
}
