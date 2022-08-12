import 'package:flutter/foundation.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SendBatchOptions.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/ISendBatchOptionsMapperService.dart';
import '../../../Crosscutting/JsonMapperService.dart';

class SendBatchOptionsMapperService extends ISendBatchOptionsMapperService {
  @override
  Future<SendBatchOptions> fromJson(String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecode, jsonString);
    var map = Map<String, dynamic>.from(result);
    return fromMap(map);
  }

  @override
  Future<SendBatchOptions> fromMap(Map<String, dynamic> map) async {
    var result = new SendBatchOptions();
    result.partitionId = map["partitionId"];
    result.partitionKey = map["partitionKey"];
    return Future.value(result);
  }

  @override
  Future<Iterable<SendBatchOptions>> fromJsonList(String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecodeList, jsonString);
    var mappedResult = List<Map<String, dynamic>>.from(result);

    var returnList = new List<SendBatchOptions>.empty(growable: true);
    for (var i = 0; i < mappedResult.length; i++) {
      var map = mappedResult[i];
      var sendBatchOptions = await fromMap(map);
      returnList.add(sendBatchOptions);
    }
    return Future.value(returnList);
  }

  @override
  Future<String> toJson(SendBatchOptions sendBatchOptions) async {
    var map = await toMap(sendBatchOptions);
    return compute(JsonMapperService.jsonEncode, map);
  }

  @override
  Future<String> toJsonFromList(
      Iterable<SendBatchOptions> sendBatchOptionsList) async {
    var mapList = new List<Map<String, dynamic>>.empty(growable: true);
    for (var i = 0; i < sendBatchOptionsList.length; i++) {
      var map = await toMap(sendBatchOptionsList.elementAt(i));
      mapList.add(map);
    }
    return compute(JsonMapperService.jsonEncodeList, mapList);
  }

  @override
  Future<Map<String, dynamic>> toMap(SendBatchOptions sendBatchOptions) async {
    var map = new Map<String, dynamic>();
    if (sendBatchOptions.partitionId != null) {
      map["partitionId"] = sendBatchOptions.partitionId;
    }
    if (sendBatchOptions.partitionKey != null) {
      map["partitionKey"] = sendBatchOptions.partitionKey;
    }
    return Future.value(map);
  }
}
