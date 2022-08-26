import 'package:flutter_azure_event_hubs/Domain/Entities/ClientSecretCredential.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SchemaDescription.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SchemaRegistryClient.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SchemaRegistryClientOptions.dart';

abstract class ISchemaRegistryClientRepositoryService {
  Future<JavascriptTransaction>
      getCreateSchemaRegistryClientJavascriptTransaction(
          SchemaRegistryClient schemaRegistryClient,
          ClientSecretCredential clientSecretCredential,
          SchemaRegistryClientOptions? schemaRegistryClientOptions);
  Future<JavascriptTransaction> getGetSchemaPropertiesJavascriptTransaction(
      SchemaRegistryClient schemaRegistryClient,
      SchemaDescription schemaDescription);
}
