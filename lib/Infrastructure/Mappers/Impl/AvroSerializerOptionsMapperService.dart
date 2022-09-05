import 'package:flutter/foundation.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/AvroSerializerOptions.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/IAvroSerializerOptionsMapperService.dart';
import '../../../Crosscutting/JsonMapperService.dart';

class AvroSerializerOptionsMapperService
    extends IAvroSerializerOptionsMapperService {
  @override
  Future<AvroSerializerOptions> fromJson(String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecode, jsonString);
    var map = Map<String, dynamic>.from(result);
    return fromMap(map);
  }

  @override
  Future<AvroSerializerOptions> fromMap(Map<String, dynamic> map) async {
    var result =
        new AvroSerializerOptions(map["autoRegisterSchemas"], map["groupName"]);
    return Future.value(result);
  }

  @override
  Future<Iterable<AvroSerializerOptions>> fromJsonList(
      String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecodeList, jsonString);
    var mappedResult = List<Map<String, dynamic>>.from(result);

    var returnList = new List<AvroSerializerOptions>.empty(growable: true);
    for (var i = 0; i < mappedResult.length; i++) {
      var map = mappedResult[i];
      var avroSerializerOptions = await fromMap(map);
      returnList.add(avroSerializerOptions);
    }
    return Future.value(returnList);
  }

  @override
  Future<String> toJson(AvroSerializerOptions avroSerializerOptions) async {
    var map = await toMap(avroSerializerOptions);
    return compute(JsonMapperService.jsonEncode, map);
  }

  @override
  Future<String> toJsonFromList(
      Iterable<AvroSerializerOptions> avroSerializerOptionsList) async {
    var mapList = new List<Map<String, dynamic>>.empty(growable: true);
    for (var i = 0; i < avroSerializerOptionsList.length; i++) {
      var map = await toMap(avroSerializerOptionsList.elementAt(i));
      mapList.add(map);
    }
    return compute(JsonMapperService.jsonEncodeList, mapList);
  }

  @override
  Future<Map<String, dynamic>> toMap(
      AvroSerializerOptions avroSerializerOptions) async {
    var map = new Map<String, dynamic>();
    if (avroSerializerOptions.autoRegisterSchemas != null) {
      map["autoRegisterSchemas"] = avroSerializerOptions.autoRegisterSchemas;
    }
    if (avroSerializerOptions.groupName != null) {
      map["groupName"] = avroSerializerOptions.groupName;
    }
    return Future.value(map);
  }
}
