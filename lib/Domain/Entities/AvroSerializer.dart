import 'package:flutter_azure_event_hubs/Domain/Entities/SchemaRegistryClient.dart';

class AvroSerializer {
  final String id;
  final SchemaRegistryClient schemaRegistryClient;
  AvroSerializer(this.id, this.schemaRegistryClient);
}
