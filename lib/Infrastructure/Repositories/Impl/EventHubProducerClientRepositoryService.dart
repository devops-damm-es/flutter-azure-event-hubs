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
    var javascriptTransactionId = Uuid().v4();
    var javascriptCode =
        "flutterAzureEventHubs.api.createEventHubProducerClient('" +
            eventHubProducerClient.id +
            "', '" +
            eventHubProducerClient.connectionString +
            "', '" +
            eventHubProducerClient.eventHubName +
            "', '" +
            javascriptTransactionId +
            "', '" +
            Uuid().v4() +
            "');";

    var javascriptTransaction =
        JavascriptTransaction(javascriptTransactionId, javascriptCode);
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

    var javascriptTransactionId = Uuid().v4();
    var javascriptCode = "flutterAzureEventHubs.api.sendEventDataBatch('" +
        eventHubProducerClient.id +
        "'," +
        jsonEventDataList +
        ", " +
        jsonSendBatchOptions +
        ", '" +
        javascriptTransactionId +
        "', '" +
        Uuid().v4() +
        "');";

    var javascriptTransaction =
        JavascriptTransaction(javascriptTransactionId, javascriptCode);
    return Future.value(javascriptTransaction);
  }

  @override
  Future<JavascriptTransaction>
      getCloseEventHubProducerClientJavascriptTransaction(
          EventHubProducerClient eventHubProducerClient) async {
    var javascriptTransactionId = Uuid().v4();
    var javascriptCode =
        "flutterAzureEventHubs.api.closeEventHubProducerClient('" +
            eventHubProducerClient.id +
            "', '" +
            javascriptTransactionId +
            "', '" +
            Uuid().v4() +
            "');";

    var javascriptTransaction =
        JavascriptTransaction(javascriptTransactionId, javascriptCode);
    return Future.value(javascriptTransaction);
  }
}
