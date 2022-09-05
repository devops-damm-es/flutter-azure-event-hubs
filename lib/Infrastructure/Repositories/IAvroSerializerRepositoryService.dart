import 'package:flutter_azure_event_hubs/Domain/Entities/AvroSerializer.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/AvroSerializerOptions.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SchemaRegistryClient.dart';

abstract class IAvroSerializerRepositoryService {
  Future<JavascriptTransaction> getCreateAvroSerializerJavascriptTransaction(
      AvroSerializer avroSerializer,
      SchemaRegistryClient schemaRegistryClient,
      AvroSerializerOptions? avroSerializerOptions);
}
