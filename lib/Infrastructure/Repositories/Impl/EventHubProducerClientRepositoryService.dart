import 'package:flutter_azure_event_hubs/Domain/Entities/EventData.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventHubProducerClient.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SendBatchOptions.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/IEventDataMapperService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/ISendBatchOptionsMapperService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IEventHubProducerClientRepositoryService.dart';
import 'package:uuid/uuid.dart';

class EventHubProducerClientRepositoryService
    extends IEventHubProducerClientRepositoryService {
  final IEventDataMapperService _eventDataMapperService;
  final ISendBatchOptionsMapperService _sendBatchOptionsMapperService;

  EventHubProducerClientRepositoryService(
      this._eventDataMapperService, this._sendBatchOptionsMapperService);

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
  Future<JavascriptTransaction> getSendEventDataBatchJavascriptTransaction(
      EventHubProducerClient eventHubProducerClient,
      Iterable<EventData> eventDataList,
      SendBatchOptions? sendBatchOptions) async {
    var jsonEventDataList =
        await _eventDataMapperService.toJsonFromList(eventDataList);
    var jsonSendBatchOptions = "{}";
    if (sendBatchOptions != null) {
      jsonSendBatchOptions =
          await _sendBatchOptionsMapperService.toJson(sendBatchOptions);
    }

    var javascriptCode =
        "var eventHubProducerClientInstance = flutterAzureEventHubs.getEventHubProducerClientByKey('" +
            eventHubProducerClient.id +
            "'); eventHubProducerClientInstance.sendBatch(" +
            jsonEventDataList +
            ", " +
            jsonSendBatchOptions +
            ");";

    var javascriptTransaction =
        JavascriptTransaction(Uuid().v4(), javascriptCode);
    return Future.value(javascriptTransaction);
  }
}
