import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SchemaRegistryClient.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SchemaRegistryClientOptions.dart';

abstract class ISchemaRegistryClientRepositoryService {
  Future<JavascriptTransaction>
      getCreateSchemaRegistryClientJavascriptTransaction(
          SchemaRegistryClient schemaRegistryClient,
          SchemaRegistryClientOptions? schemaRegistryClientOptions);
}
