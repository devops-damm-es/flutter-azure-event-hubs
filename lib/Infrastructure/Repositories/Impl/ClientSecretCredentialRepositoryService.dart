import 'package:flutter_azure_event_hubs/Domain/Entities/ClientSecretCredential.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/TokenCredentialOptions.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/ITokenCredentialOptionsMapperService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IClientSecretCredentialRepositoryService.dart';
import 'package:uuid/uuid.dart';

class ClientSecretCredentialRepositoryService
    extends IClientSecretCredentialRepositoryService {
  final ITokenCredentialOptionsMapperService
      _tokenCredentialOptionsMapperService;

  ClientSecretCredentialRepositoryService(
      this._tokenCredentialOptionsMapperService);

  @override
  Future<JavascriptTransaction>
      getCreateClientSecretCredentialJavascriptTransaction(
          ClientSecretCredential clientSecretCredential,
          TokenCredentialOptions? tokenCredentialOptions) async {
    var jsonTokenCredentialOptions = "{}";
    if (tokenCredentialOptions != null) {
      jsonTokenCredentialOptions = await _tokenCredentialOptionsMapperService
          .toJson(tokenCredentialOptions);
    }

    var javascriptTransactionId = Uuid().v4();
    var javascriptCode =
        "flutterAzureEventHubs.api.createClientSecretCredential('" +
            clientSecretCredential.id +
            "', '" +
            clientSecretCredential.tenantId +
            "', '" +
            clientSecretCredential.clientId +
            "', '" +
            clientSecretCredential.clientSecret +
            "', " +
            jsonTokenCredentialOptions +
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
