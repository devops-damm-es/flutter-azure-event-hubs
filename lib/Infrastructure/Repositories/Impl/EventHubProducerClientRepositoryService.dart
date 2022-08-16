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
    var javascriptCode = "try {" +
        "var eventHubProducerClientInstance = new flutterAzureEventHubs.eventHubProducerClient('" +
        eventHubProducerClient.connectionString +
        "', '" +
        eventHubProducerClient.eventHubName +
        "'); flutterAzureEventHubs.setEventHubProducerClient('" +
        eventHubProducerClient.id +
        "', eventHubProducerClientInstance);" +
        "proxyInterop.postMessage('{\"id\":\"" +
        Uuid().v4() +
        "\",\"javascriptTransactionId\":\"" +
        javascriptTransactionId +
        "\",\"success\":true,\"result\":\"\"}');"
            "} catch (error) {" +
        "proxyInterop.postMessage('{\"id\":\"" +
        Uuid().v4() +
        "\",\"javascriptTransactionId\":\"" +
        javascriptTransactionId +
        "\",\"success\":false,\"result\":\"' + error + '\"}');"
            "}";

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
    var javascriptCode =
        "var eventHubProducerClientInstance = flutterAzureEventHubs.getEventHubProducerClientByKey('" +
            eventHubProducerClient.id +
            "'); if (eventHubProducerClientInstance != null) {" +
            "eventHubProducerClientInstance.sendBatch(" +
            jsonEventDataList +
            ", " +
            jsonSendBatchOptions +
            ").then(function(value) {" +
            "proxyInterop.postMessage('{\"id\":\"" +
            Uuid().v4() +
            "\",\"javascriptTransactionId\":\"" +
            javascriptTransactionId +
            "\",\"success\":true,\"result\":\"\"}');" +
            "}).catch(function(error) {" +
            "proxyInterop.postMessage('{\"id\":\"" +
            Uuid().v4() +
            "\",\"javascriptTransactionId\":\"" +
            javascriptTransactionId +
            "\",\"success\":false,\"result\":\"' + error + '\"}');" +
            "}); } else {" +
            "proxyInterop.postMessage('{\"id\":\"" +
            Uuid().v4() +
            "\",\"javascriptTransactionId\":\"" +
            javascriptTransactionId +
            "\",\"success\":false,\"result\":\"ERROR: EventHubProducerClient not found.\"}');" +
            "}";

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
        "var eventHubProducerClientInstance = flutterAzureEventHubs.getEventHubProducerClientByKey('" +
            eventHubProducerClient.id +
            "'); if (eventHubProducerClientInstance != null) {" +
            " eventHubProducerClientInstance.close().then(function(value) {" +
            "flutterAzureEventHubs.removeEventHubProducerClientByKey('" +
            eventHubProducerClient.id +
            "');" +
            "proxyInterop.postMessage('{\"id\":\"" +
            Uuid().v4() +
            "\",\"javascriptTransactionId\":\"" +
            javascriptTransactionId +
            "\",\"success\":true,\"result\":\"\"}');" +
            "}).catch(function(error) {" +
            "proxyInterop.postMessage('{\"id\":\"" +
            Uuid().v4() +
            "\",\"javascriptTransactionId\":\"" +
            javascriptTransactionId +
            "\",\"success\":false,\"result\":\"' + error + '\"}');" +
            "}); } else {" +
            "proxyInterop.postMessage('{\"id\":\"" +
            Uuid().v4() +
            "\",\"javascriptTransactionId\":\"" +
            javascriptTransactionId +
            "\",\"success\":false,\"result\":\"ERROR: EventHubProducerClient not found.\"}');" +
            "}";

    var javascriptTransaction =
        JavascriptTransaction(javascriptTransactionId, javascriptCode);
    return Future.value(javascriptTransaction);
  }
}
