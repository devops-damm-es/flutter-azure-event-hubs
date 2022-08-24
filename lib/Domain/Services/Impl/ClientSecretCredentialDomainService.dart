import 'package:flutter_azure_event_hubs/Domain/Services/IClientSecretCredentialDomainService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IClientSecretCredentialRepositoryService.dart';

class ClientSecretCredentialDomainService
    extends IClientSecretCredentialDomainService {
  final IClientSecretCredentialRepositoryService _repositoryService;

  ClientSecretCredentialDomainService(this._repositoryService);

  @override
  IClientSecretCredentialRepositoryService get repositoryService =>
      _repositoryService;
}
