import 'package:flutter_azure_event_hubs/Domain/Entities/SchemaDescription.dart';

abstract class ISchemaDescriptionMapperService {
  Future<SchemaDescription> fromJson(String jsonString);
  Future<SchemaDescription> fromMap(Map<String, dynamic> map);
  Future<Iterable<SchemaDescription>> fromJsonList(String jsonString);
  Future<String> toJson(SchemaDescription schemaDescription);
  Future<String> toJsonFromList(
      Iterable<SchemaDescription> schemaDescriptionList);
  Future<Map<String, dynamic>> toMap(SchemaDescription schemaDescription);
}
