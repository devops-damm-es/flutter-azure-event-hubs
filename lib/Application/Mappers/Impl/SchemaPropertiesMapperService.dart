import 'package:flutter/foundation.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/ISchemaPropertiesMapperService.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SchemaProperties.dart';
import '../../../Crosscutting/JsonMapperService.dart';

class SchemaPropertiesMapperService extends ISchemaPropertiesMapperService {
  @override
  Future<SchemaProperties> fromJson(String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecode, jsonString);
    var map = Map<String, dynamic>.from(result);
    return fromMap(map);
  }

  @override
  Future<SchemaProperties> fromMap(Map<String, dynamic> map) async {
    var result = new SchemaProperties(
        map["id"], map["format"], map["groupName"], map["name"]);
    return Future.value(result);
  }

  @override
  Future<Iterable<SchemaProperties>> fromJsonList(String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecodeList, jsonString);
    var mappedResult = List<Map<String, dynamic>>.from(result);

    var returnList = new List<SchemaProperties>.empty(growable: true);
    for (var i = 0; i < mappedResult.length; i++) {
      var map = mappedResult[i];
      var schemaProperties = await fromMap(map);
      returnList.add(schemaProperties);
    }
    return Future.value(returnList);
  }

  @override
  Future<String> toJson(SchemaProperties schemaProperties) async {
    var map = await toMap(schemaProperties);
    return compute(JsonMapperService.jsonEncode, map);
  }

  @override
  Future<String> toJsonFromList(
      Iterable<SchemaProperties> schemaPropertiesList) async {
    var mapList = new List<Map<String, dynamic>>.empty(growable: true);
    for (var i = 0; i < schemaPropertiesList.length; i++) {
      var map = await toMap(schemaPropertiesList.elementAt(i));
      mapList.add(map);
    }
    return compute(JsonMapperService.jsonEncodeList, mapList);
  }

  @override
  Future<Map<String, dynamic>> toMap(SchemaProperties schemaProperties) async {
    var map = new Map<String, dynamic>();
    map["id"] = schemaProperties.id;
    map["format"] = schemaProperties.format;
    map["groupName"] = schemaProperties.groupName;
    map["name"] = schemaProperties.name;
    return Future.value(map);
  }
}
