import 'package:flutter/foundation.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/IIncomingEventMapperService.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/IPartitionContextMapperService.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/IReceivedEventDataMapperService.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/IncomingEvent.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/ReceivedEventData.dart';
import '../../../Crosscutting/JsonMapperService.dart';

class IncomingEventMapperService extends IIncomingEventMapperService {
  final IReceivedEventDataMapperService _receivedEventDataMapperService;
  final IPartitionContextMapperService _partitionContextMapperService;

  IncomingEventMapperService(this._receivedEventDataMapperService,
      this._partitionContextMapperService);

  @override
  Future<IncomingEvent> fromJson(String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecode, jsonString);
    var map = Map<String, dynamic>.from(result);
    return fromMap(map);
  }

  @override
  Future<IncomingEvent> fromMap(Map<String, dynamic> map) async {
    var receivedEventDataList =
        new List<ReceivedEventData>.empty(growable: true);
    var mappedResult =
        List<Map<String, dynamic>>.from(map["receivedEventDataList"]);
    for (var mappedResultEntry in mappedResult) {
      var receivedEventData =
          await _receivedEventDataMapperService.fromMap(mappedResultEntry);
      receivedEventDataList.add(receivedEventData);
    }
    var result = new IncomingEvent(receivedEventDataList,
        await _partitionContextMapperService.fromMap(map["partitionContext"]));
    return Future.value(result);
  }

  @override
  Future<Iterable<IncomingEvent>> fromJsonList(String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecodeList, jsonString);
    var mappedResult = List<Map<String, dynamic>>.from(result);

    var returnList = new List<IncomingEvent>.empty(growable: true);
    for (var i = 0; i < mappedResult.length; i++) {
      var map = mappedResult[i];
      var incomingEvent = await fromMap(map);
      returnList.add(incomingEvent);
    }
    return Future.value(returnList);
  }

  @override
  Future<String> toJson(IncomingEvent incomingEvent) async {
    var map = await toMap(incomingEvent);
    return compute(JsonMapperService.jsonEncode, map);
  }

  @override
  Future<String> toJsonFromList(
      Iterable<IncomingEvent> incomingEventList) async {
    var mapList = new List<Map<String, dynamic>>.empty(growable: true);
    for (var i = 0; i < incomingEventList.length; i++) {
      var map = await toMap(incomingEventList.elementAt(i));
      mapList.add(map);
    }
    return compute(JsonMapperService.jsonEncodeList, mapList);
  }

  @override
  Future<Map<String, dynamic>> toMap(IncomingEvent incomingEvent) async {
    var map = new Map<String, dynamic>();
    var mapList = new List<Map<String, dynamic>>.empty(growable: true);
    for (var receivedEventData
        in incomingEvent.receivedEventDataList.toList()) {
      mapList
          .add(await _receivedEventDataMapperService.toMap(receivedEventData));
    }
    map["receivedEventDataList"] = mapList;
    map["partitionContext"] = await _partitionContextMapperService
        .toMap(incomingEvent.partitionContext);
    return Future.value(map);
  }
}
