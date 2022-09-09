import 'package:flutter/foundation.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/DeserializeOptions.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/IDeserializeOptionsMapperService.dart';
import '../../../Crosscutting/JsonMapperService.dart';

class DeserializeOptionsMapperService extends IDeserializeOptionsMapperService {
  @override
  Future<DeserializeOptions> fromJson(String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecode, jsonString);
    var map = Map<String, dynamic>.from(result);
    return fromMap(map);
  }

  @override
  Future<DeserializeOptions> fromMap(Map<String, dynamic> map) async {
    var result = new DeserializeOptions(map["schema"]);
    return Future.value(result);
  }

  @override
  Future<Iterable<DeserializeOptions>> fromJsonList(String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecodeList, jsonString);
    var mappedResult = List<Map<String, dynamic>>.from(result);

    var returnList = new List<DeserializeOptions>.empty(growable: true);
    for (var i = 0; i < mappedResult.length; i++) {
      var map = mappedResult[i];
      var deserializeOptions = await fromMap(map);
      returnList.add(deserializeOptions);
    }
    return Future.value(returnList);
  }

  @override
  Future<String> toJson(DeserializeOptions deserializeOptions) async {
    var map = await toMap(deserializeOptions);
    return compute(JsonMapperService.jsonEncode, map);
  }

  @override
  Future<String> toJsonFromList(
      Iterable<DeserializeOptions> deserializeOptionsList) async {
    var mapList = new List<Map<String, dynamic>>.empty(growable: true);
    for (var i = 0; i < deserializeOptionsList.length; i++) {
      var map = await toMap(deserializeOptionsList.elementAt(i));
      mapList.add(map);
    }
    return compute(JsonMapperService.jsonEncodeList, mapList);
  }

  @override
  Future<Map<String, dynamic>> toMap(
      DeserializeOptions deserializeOptions) async {
    var map = new Map<String, dynamic>();
    map["schema"] = deserializeOptions.schema;
    return Future.value(map);
  }
}
