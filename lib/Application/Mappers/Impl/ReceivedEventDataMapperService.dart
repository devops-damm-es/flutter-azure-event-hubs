import 'package:flutter/foundation.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/IDateTimeMapperService.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/IReceivedEventDataMapperService.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/ReceivedEventData.dart';
import '../../../Crosscutting/JsonMapperService.dart';

class ReceivedEventDataMapperService extends IReceivedEventDataMapperService {
  final IDateTimeMapperService _dateTimeMapperService;

  ReceivedEventDataMapperService(this._dateTimeMapperService);

  @override
  Future<ReceivedEventData> fromJson(String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecode, jsonString);
    var map = Map<String, dynamic>.from(result);
    return fromMap(map);
  }

  @override
  Future<ReceivedEventData> fromMap(Map<String, dynamic> map) async {
    var result = new ReceivedEventData(
        map["body"],
        map["contentType"],
        await _dateTimeMapperService.toDateTimeUtc(map["enqueuedTimeUtc"]),
        map["partitionKey"],
        map["offset"],
        map["sequenceNumber"]);
    return Future.value(result);
  }

  @override
  Future<Iterable<ReceivedEventData>> fromJsonList(String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecodeList, jsonString);
    var mappedResult = List<Map<String, dynamic>>.from(result);

    var returnList = new List<ReceivedEventData>.empty(growable: true);
    for (var i = 0; i < mappedResult.length; i++) {
      var map = mappedResult[i];
      var receivedEventData = await fromMap(map);
      returnList.add(receivedEventData);
    }
    return Future.value(returnList);
  }

  @override
  Future<String> toJson(ReceivedEventData receivedEventData) async {
    var map = await toMap(receivedEventData);
    return compute(JsonMapperService.jsonEncode, map);
  }

  @override
  Future<String> toJsonFromList(
      Iterable<ReceivedEventData> receivedEventDataList) async {
    var mapList = new List<Map<String, dynamic>>.empty(growable: true);
    for (var i = 0; i < receivedEventDataList.length; i++) {
      var map = await toMap(receivedEventDataList.elementAt(i));
      mapList.add(map);
    }
    return compute(JsonMapperService.jsonEncodeList, mapList);
  }

  @override
  Future<Map<String, dynamic>> toMap(
      ReceivedEventData receivedEventData) async {
    var map = new Map<String, dynamic>();
    map["body"] = receivedEventData.body;
    if (receivedEventData.contentType != null) {
      map["contentType"] = receivedEventData.contentType;
    }
    map["enqueuedTimeUtc"] = await _dateTimeMapperService
        .toStringDateTimeUtc(receivedEventData.enqueuedTimeUtc);
    map["partitionKey"] = receivedEventData.partitionKey;
    map["offset"] = receivedEventData.offset;
    map["sequenceNumber"] = receivedEventData.sequenceNumber;
    return Future.value(map);
  }
}
