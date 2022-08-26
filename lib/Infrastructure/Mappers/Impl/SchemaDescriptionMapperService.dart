import 'package:flutter/foundation.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SchemaDescription.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/ISchemaDescriptionMapperService.dart';
import '../../../Crosscutting/JsonMapperService.dart';

class SchemaDescriptionMapperService extends ISchemaDescriptionMapperService {
  @override
  Future<SchemaDescription> fromJson(String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecode, jsonString);
    var map = Map<String, dynamic>.from(result);
    return fromMap(map);
  }

  @override
  Future<SchemaDescription> fromMap(Map<String, dynamic> map) async {
    var result = new SchemaDescription(
        map["groupName"], map["name"], map["format"], map["definition"]);
    return Future.value(result);
  }

  @override
  Future<Iterable<SchemaDescription>> fromJsonList(String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecodeList, jsonString);
    var mappedResult = List<Map<String, dynamic>>.from(result);

    var returnList = new List<SchemaDescription>.empty(growable: true);
    for (var i = 0; i < mappedResult.length; i++) {
      var map = mappedResult[i];
      var schemaDescription = await fromMap(map);
      returnList.add(schemaDescription);
    }
    return Future.value(returnList);
  }

  @override
  Future<String> toJson(SchemaDescription schemaDescription) async {
    var map = await toMap(schemaDescription);
    return compute(JsonMapperService.jsonEncode, map);
  }

  @override
  Future<String> toJsonFromList(
      Iterable<SchemaDescription> schemaDescriptionList) async {
    var mapList = new List<Map<String, dynamic>>.empty(growable: true);
    for (var i = 0; i < schemaDescriptionList.length; i++) {
      var map = await toMap(schemaDescriptionList.elementAt(i));
      mapList.add(map);
    }
    return compute(JsonMapperService.jsonEncodeList, mapList);
  }

  @override
  Future<Map<String, dynamic>> toMap(
      SchemaDescription schemaDescription) async {
    var map = new Map<String, dynamic>();
    map["groupName"] = schemaDescription.groupName;
    map["name"] = schemaDescription.name;
    map["format"] = schemaDescription.format;
    map["definition"] = schemaDescription.definition;
    return Future.value(map);
  }
}
