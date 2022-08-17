import 'package:flutter/foundation.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SubscribeOptions.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/IEventPositionMapperService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/ISubscribeOptionsMapperService.dart';
import '../../../Crosscutting/JsonMapperService.dart';

class SubscribeOptionsMapperService extends ISubscribeOptionsMapperService {
  final IEventPositionMapperService _eventPositionMapperService;

  SubscribeOptionsMapperService(this._eventPositionMapperService);

  @override
  Future<SubscribeOptions> fromJson(String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecode, jsonString);
    var map = Map<String, dynamic>.from(result);
    return fromMap(map);
  }

  @override
  Future<SubscribeOptions> fromMap(Map<String, dynamic> map) async {
    var result = new SubscribeOptions(
        map["maxBatchSize"],
        map["maxWaitTimeInSeconds"],
        map["startPosition"] != null
            ? await _eventPositionMapperService.fromMap(map["startPosition"])
            : null,
        map["trackLastEnqueuedEventProperties"],
        map["ownerLevel"],
        map["skipParsingBodyAsJson"]);
    return Future.value(result);
  }

  @override
  Future<Iterable<SubscribeOptions>> fromJsonList(String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecodeList, jsonString);
    var mappedResult = List<Map<String, dynamic>>.from(result);

    var returnList = new List<SubscribeOptions>.empty(growable: true);
    for (var i = 0; i < mappedResult.length; i++) {
      var map = mappedResult[i];
      var subscribeOptions = await fromMap(map);
      returnList.add(subscribeOptions);
    }
    return Future.value(returnList);
  }

  @override
  Future<String> toJson(SubscribeOptions subscribeOptions) async {
    var map = await toMap(subscribeOptions);
    return compute(JsonMapperService.jsonEncode, map);
  }

  @override
  Future<String> toJsonFromList(
      Iterable<SubscribeOptions> subscribeOptionsList) async {
    var mapList = new List<Map<String, dynamic>>.empty(growable: true);
    for (var i = 0; i < subscribeOptionsList.length; i++) {
      var map = await toMap(subscribeOptionsList.elementAt(i));
      mapList.add(map);
    }
    return compute(JsonMapperService.jsonEncodeList, mapList);
  }

  @override
  Future<Map<String, dynamic>> toMap(SubscribeOptions subscribeOptions) async {
    var map = new Map<String, dynamic>();
    if (subscribeOptions.maxBatchSize != null) {
      map["maxBatchSize"] = subscribeOptions.maxBatchSize;
    }
    if (subscribeOptions.maxWaitTimeInSeconds != null) {
      map["maxWaitTimeInSeconds"] = subscribeOptions.maxWaitTimeInSeconds;
    }
    if (subscribeOptions.startPosition != null) {
      map["startPosition"] = await _eventPositionMapperService
          .toMap(subscribeOptions.startPosition!);
    }
    if (subscribeOptions.trackLastEnqueuedEventProperties != null) {
      map["trackLastEnqueuedEventProperties"] =
          subscribeOptions.trackLastEnqueuedEventProperties;
    }
    if (subscribeOptions.ownerLevel != null) {
      map["ownerLevel"] = subscribeOptions.ownerLevel;
    }
    if (subscribeOptions.skipParsingBodyAsJson != null) {
      map["skipParsingBodyAsJson"] = subscribeOptions.skipParsingBodyAsJson;
    }
    return Future.value(map);
  }
}
