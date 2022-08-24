import 'package:flutter/foundation.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SchemaRegistryClientOptions.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/ISchemaRegistryClientOptionsMapperService.dart';
import '../../../Crosscutting/JsonMapperService.dart';

class SchemaRegistryClientOptionsMapperService
    extends ISchemaRegistryClientOptionsMapperService {
  @override
  Future<SchemaRegistryClientOptions> fromJson(String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecode, jsonString);
    var map = Map<String, dynamic>.from(result);
    return fromMap(map);
  }

  @override
  Future<SchemaRegistryClientOptions> fromMap(Map<String, dynamic> map) async {
    var result = new SchemaRegistryClientOptions(
        map["apiVersion"], map["allowInsecureConnection"]);
    return Future.value(result);
  }

  @override
  Future<Iterable<SchemaRegistryClientOptions>> fromJsonList(
      String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecodeList, jsonString);
    var mappedResult = List<Map<String, dynamic>>.from(result);

    var returnList =
        new List<SchemaRegistryClientOptions>.empty(growable: true);
    for (var i = 0; i < mappedResult.length; i++) {
      var map = mappedResult[i];
      var schemaRegistryClientOptions = await fromMap(map);
      returnList.add(schemaRegistryClientOptions);
    }
    return Future.value(returnList);
  }

  @override
  Future<String> toJson(
      SchemaRegistryClientOptions schemaRegistryClientOptions) async {
    var map = await toMap(schemaRegistryClientOptions);
    return compute(JsonMapperService.jsonEncode, map);
  }

  @override
  Future<String> toJsonFromList(
      Iterable<SchemaRegistryClientOptions>
          schemaRegistryClientOptionsList) async {
    var mapList = new List<Map<String, dynamic>>.empty(growable: true);
    for (var i = 0; i < schemaRegistryClientOptionsList.length; i++) {
      var map = await toMap(schemaRegistryClientOptionsList.elementAt(i));
      mapList.add(map);
    }
    return compute(JsonMapperService.jsonEncodeList, mapList);
  }

  @override
  Future<Map<String, dynamic>> toMap(
      SchemaRegistryClientOptions schemaRegistryClientOptions) async {
    var map = new Map<String, dynamic>();
    if (schemaRegistryClientOptions.apiVersion != null) {
      map["apiVersion"] = schemaRegistryClientOptions.apiVersion;
    }
    if (schemaRegistryClientOptions.allowInsecureConnection != null) {
      map["allowInsecureConnection"] =
          schemaRegistryClientOptions.allowInsecureConnection;
    }
    return Future.value(map);
  }
}
