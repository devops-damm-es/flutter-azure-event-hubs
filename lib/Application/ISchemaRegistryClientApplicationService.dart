import 'dart:async';

import 'package:flutter_azure_event_hubs/Domain/Entities/ClientSecretCredential.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SchemaRegistryClient.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SchemaRegistryClientOptions.dart';

abstract class ISchemaRegistryClientApplicationService {
  Future<SchemaRegistryClient> createSchemaRegistryClient(
      String fullyQualifiedNamespace,
      ClientSecretCredential clientSecretCredential,
      {SchemaRegistryClientOptions? schemaRegistryClientOptions});
}
