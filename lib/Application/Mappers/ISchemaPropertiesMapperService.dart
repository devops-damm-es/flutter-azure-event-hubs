import 'package:flutter_azure_event_hubs/Domain/Entities/SchemaProperties.dart';

abstract class ISchemaPropertiesMapperService {
  Future<SchemaProperties> fromJson(String jsonString);
  Future<SchemaProperties> fromMap(Map<String, dynamic> map);
  Future<Iterable<SchemaProperties>> fromJsonList(String jsonString);
  Future<String> toJson(SchemaProperties schemaProperties);
  Future<String> toJsonFromList(
      Iterable<SchemaProperties> schemaPropertiesList);
  Future<Map<String, dynamic>> toMap(SchemaProperties schemaProperties);
}
