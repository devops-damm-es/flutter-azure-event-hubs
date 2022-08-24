import 'dart:async';

import 'package:flutter_azure_event_hubs/Domain/Entities/ClientSecretCredential.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/TokenCredentialOptions.dart';

abstract class IClientSecretCredentialApplicationService {
  Future<ClientSecretCredential> createClientSecretCredential(
      String tenantId, String clientId, String clientSecret,
      {TokenCredentialOptions? tokenCredentialOptions});
}
