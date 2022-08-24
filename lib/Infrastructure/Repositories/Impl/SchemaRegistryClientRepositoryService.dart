import 'package:flutter_azure_event_hubs/Domain/Entities/ClientSecretCredential.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SchemaRegistryClient.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SchemaRegistryClientOptions.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/ISchemaRegistryClientOptionsMapperService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/ISchemaRegistryClientRepositoryService.dart';
import 'package:uuid/uuid.dart';

class SchemaRegistryClientRepositoryService
    extends ISchemaRegistryClientRepositoryService {
  final ISchemaRegistryClientOptionsMapperService
      _schemaRegistryClientOptionsMapperService;

  SchemaRegistryClientRepositoryService(
      this._schemaRegistryClientOptionsMapperService);

  @override
  Future<JavascriptTransaction>
      getCreateSchemaRegistryClientJavascriptTransaction(
          SchemaRegistryClient schemaRegistryClient,
          ClientSecretCredential clientSecretCredential,
          SchemaRegistryClientOptions? schemaRegistryClientOptions) async {
    var jsonSchemaRegistryClientOptions = "{}";
    if (schemaRegistryClientOptions != null) {
      jsonSchemaRegistryClientOptions =
          await _schemaRegistryClientOptionsMapperService
              .toJson(schemaRegistryClientOptions);
    }

    var javascriptTransactionId = Uuid().v4();
    var javascriptCode =
        "flutterAzureEventHubs.api.createSchemaRegistryClient('" +
            schemaRegistryClient.id +
            "', '" +
            schemaRegistryClient.fullyQualifiedNamespace +
            "', '" +
            clientSecretCredential.id +
            "', " +
            jsonSchemaRegistryClientOptions +
            ", '" +
            javascriptTransactionId +
            "', '" +
            Uuid().v4() +
            "');";

    var javascriptTransaction =
        JavascriptTransaction(javascriptTransactionId, javascriptCode);
    return Future.value(javascriptTransaction);
  }
}
