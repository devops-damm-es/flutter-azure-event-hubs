import 'package:flutter_azure_event_hubs/Domain/Entities/ClientSecretCredential.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/TokenCredentialOptions.dart';

abstract class IClientSecretCredentialRepositoryService {
  Future<JavascriptTransaction>
      getCreateClientSecretCredentialJavascriptTransaction(
          ClientSecretCredential clientSecretCredential,
          TokenCredentialOptions? tokenCredentialOptions);
}
