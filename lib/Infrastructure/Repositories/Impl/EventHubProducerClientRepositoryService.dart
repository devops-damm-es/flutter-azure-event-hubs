import 'package:flutter_azure_event_hubs/Domain/Entities/EventData.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventHubProducerClient.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/IEventDataMapperService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IEventHubProducerClientRepositoryService.dart';
import 'package:uuid/uuid.dart';

class EventHubProducerClientRepositoryService
    extends IEventHubProducerClientRepositoryService {
  final IEventDataMapperService _eventDataMapperService;

  EventHubProducerClientRepositoryService(this._eventDataMapperService);

  @override
  Future<JavascriptTransaction>
      getCreateEventHubProducerClientJavascriptTransaction(
          EventHubProducerClient eventHubProducerClient) async {
    var javascriptCode =
        "var eventHubProducerClientInstance = new flutterAzureEventHubs.eventHubProducerClient('" +
            eventHubProducerClient.connectionString +
            "', '" +
            eventHubProducerClient.eventHubName +
            "'); flutterAzureEventHubs.setEventHubProducerClient('" +
            eventHubProducerClient.id +
            "', eventHubProducerClientInstance);";

    var javascriptTransaction =
        JavascriptTransaction(Uuid().v4(), javascriptCode);
    return Future.value(javascriptTransaction);
  }

  @override
  Future<JavascriptTransaction> getSendBatchJavascriptTransaction(
      EventHubProducerClient eventHubProducerClient,
      Iterable<EventData> eventDataList) async {
    var jsonEventDataList =
        await _eventDataMapperService.toJsonFromList(eventDataList);
    var javascriptCode =
        "var eventHubProducerClientInstance = flutterAzureEventHubs.getEventHubProducerClientByKey('" +
            eventHubProducerClient.id +
            "'); eventHubProducerClientInstance.sendBatch(" +
            jsonEventDataList +
            ", {});";

    var javascriptTransaction =
        JavascriptTransaction(Uuid().v4(), javascriptCode);
    return Future.value(javascriptTransaction);
  }
}
