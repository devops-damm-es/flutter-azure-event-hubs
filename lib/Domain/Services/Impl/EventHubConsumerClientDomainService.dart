import 'package:flutter_azure_event_hubs/Domain/Services/IEventHubConsumerClientDomainService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IEventHubConsumerClientRepositoryService.dart';

class EventHubConsumerClientDomainService
    extends IEventHubConsumerClientDomainService {
  final IEventHubConsumerClientRepositoryService _repositoryService;

  EventHubConsumerClientDomainService(this._repositoryService);

  @override
  IEventHubConsumerClientRepositoryService get repositoryService =>
      _repositoryService;
}
