import 'package:flutter_azure_event_hubs/Application/IEventHubProducerClientApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/IJavascriptApplicationService.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventData.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventHubProducerClient.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/IEventHubProducerClientDomainService.dart';
import 'package:uuid/uuid.dart';

class EventHubProducerClientApplicationService
    extends IEventHubProducerClientApplicationService {
  final IEventHubProducerClientDomainService
      _eventHubProducerClientDomainService;
  final IJavascriptApplicationService _javascriptApplicationService;

  EventHubProducerClientApplicationService(
      this._eventHubProducerClientDomainService,
      this._javascriptApplicationService);

  Future<EventHubProducerClient> createEventHubProducerClient(
      String connectionString, String eventHubName) async {
    var eventHubProducerClient =
        EventHubProducerClient(Uuid().v4(), connectionString, eventHubName);

    var createEventHubProducerClientJavascriptTransaction =
        await _eventHubProducerClientDomainService.repositoryService
            .getCreateEventHubProducerClientJavascriptTransaction(
                eventHubProducerClient);
    _javascriptApplicationService.executeJavascriptCode(
        createEventHubProducerClientJavascriptTransaction);

    return Future.value(eventHubProducerClient);
  }

  Future<void> sendBatch(EventHubProducerClient eventHubProducerClient,
      Iterable<EventData> eventDataList) async {
    var sendBatchJavascriptTransaction =
        await _eventHubProducerClientDomainService.repositoryService
            .getSendBatchJavascriptTransaction(
                eventHubProducerClient, eventDataList);

    _javascriptApplicationService
        .executeJavascriptCode(sendBatchJavascriptTransaction);
  }
}
