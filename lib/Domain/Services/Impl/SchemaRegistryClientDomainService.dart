import 'package:flutter_azure_event_hubs/Domain/Services/ISchemaRegistryClientDomainService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/ISchemaRegistryClientRepositoryService.dart';

class SchemaRegistryClientDomainService
    extends ISchemaRegistryClientDomainService {
  final ISchemaRegistryClientRepositoryService _repositoryService;

  SchemaRegistryClientDomainService(this._repositoryService);

  @override
  ISchemaRegistryClientRepositoryService get repositoryService =>
      _repositoryService;
}
