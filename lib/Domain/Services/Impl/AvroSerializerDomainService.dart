import 'package:flutter_azure_event_hubs/Domain/Services/IAvroSerializerDomainService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IAvroSerializerRepositoryService.dart';

class AvroSerializerDomainService extends IAvroSerializerDomainService {
  final IAvroSerializerRepositoryService _repositoryService;

  AvroSerializerDomainService(this._repositoryService);

  @override
  IAvroSerializerRepositoryService get repositoryService => _repositoryService;
}
