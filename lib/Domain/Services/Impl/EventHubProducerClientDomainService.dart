import 'package:flutter_azure_event_hubs/Domain/Services/IEventHubProducerClientDomainService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IEventHubProducerClientRepositoryService.dart';

class EventHubProducerClientDomainService
    extends IEventHubProducerClientDomainService {
  final IEventHubProducerClientRepositoryService _repositoryService;

  EventHubProducerClientDomainService(this._repositoryService);

  @override
  IEventHubProducerClientRepositoryService get repositoryService =>
      _repositoryService;
}
