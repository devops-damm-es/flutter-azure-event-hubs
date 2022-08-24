import 'package:flutter_azure_event_hubs/Domain/Entities/SchemaRegistryClientOptions.dart';

abstract class ISchemaRegistryClientOptionsMapperService {
  Future<SchemaRegistryClientOptions> fromJson(String jsonString);
  Future<SchemaRegistryClientOptions> fromMap(Map<String, dynamic> map);
  Future<Iterable<SchemaRegistryClientOptions>> fromJsonList(String jsonString);
  Future<String> toJson(
      SchemaRegistryClientOptions schemaRegistryClientOptions);
  Future<String> toJsonFromList(
      Iterable<SchemaRegistryClientOptions> schemaRegistryClientOptionsList);
  Future<Map<String, dynamic>> toMap(
      SchemaRegistryClientOptions schemaRegistryClientOptions);
}
