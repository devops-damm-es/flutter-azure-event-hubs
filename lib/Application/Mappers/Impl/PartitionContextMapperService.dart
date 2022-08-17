import 'package:flutter/foundation.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/IPartitionContextMapperService.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/PartitionContext.dart';
import '../../../Crosscutting/JsonMapperService.dart';

class PartitionContextMapperService extends IPartitionContextMapperService {
  @override
  Future<PartitionContext> fromJson(String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecode, jsonString);
    var map = Map<String, dynamic>.from(result);
    return fromMap(map);
  }

  @override
  Future<PartitionContext> fromMap(Map<String, dynamic> map) async {
    var result = new PartitionContext(map["fullyQualifiedNamespace"],
        map["eventHubName"], map["consumerGroup"], map["partitionId"]);
    return Future.value(result);
  }

  @override
  Future<Iterable<PartitionContext>> fromJsonList(String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecodeList, jsonString);
    var mappedResult = List<Map<String, dynamic>>.from(result);

    var returnList = new List<PartitionContext>.empty(growable: true);
    for (var i = 0; i < mappedResult.length; i++) {
      var map = mappedResult[i];
      var partitionContext = await fromMap(map);
      returnList.add(partitionContext);
    }
    return Future.value(returnList);
  }

  @override
  Future<String> toJson(PartitionContext partitionContext) async {
    var map = await toMap(partitionContext);
    return compute(JsonMapperService.jsonEncode, map);
  }

  @override
  Future<String> toJsonFromList(
      Iterable<PartitionContext> partitionContextList) async {
    var mapList = new List<Map<String, dynamic>>.empty(growable: true);
    for (var i = 0; i < partitionContextList.length; i++) {
      var map = await toMap(partitionContextList.elementAt(i));
      mapList.add(map);
    }
    return compute(JsonMapperService.jsonEncodeList, mapList);
  }

  @override
  Future<Map<String, dynamic>> toMap(PartitionContext partitionContext) async {
    var map = new Map<String, dynamic>();
    map["fullyQualifiedNamespace"] = partitionContext.fullyQualifiedNamespace;
    map["eventHubName"] = partitionContext.eventHubName;
    map["consumerGroup"] = partitionContext.consumerGroup;
    map["partitionId"] = partitionContext.partitionId;
    return Future.value(map);
  }
}
