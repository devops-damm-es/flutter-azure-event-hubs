import 'package:flutter_azure_event_hubs/Domain/Entities/EventHubConsumerClient.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SubscribeOptions.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/ISubscribeOptionsMapperService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IEventHubConsumerClientRepositoryService.dart';
import 'package:uuid/uuid.dart';

class EventHubConsumerClientRepositoryService
    extends IEventHubConsumerClientRepositoryService {
  final ISubscribeOptionsMapperService _subscribeOptionsMapperService;

  EventHubConsumerClientRepositoryService(this._subscribeOptionsMapperService);

  @override
  Future<JavascriptTransaction>
      getCreateEventHubConsumerClientJavascriptTransaction(
          EventHubConsumerClient eventHubConsumerClient) async {
    var javascriptTransactionId = Uuid().v4();
    var javascriptCode = "try {" +
        "var eventHubConsumerClientInstance = new flutterAzureEventHubs.eventHubConsumerClient('" +
        eventHubConsumerClient.consumerGroup +
        "', '" +
        eventHubConsumerClient.connectionString +
        "', '" +
        eventHubConsumerClient.eventHubName +
        "'); flutterAzureEventHubs.setEventHubConsumerClient('" +
        eventHubConsumerClient.id +
        "', eventHubConsumerClientInstance);" +
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
  Future<JavascriptTransaction> getSubscribeJavascriptTransaction(
      EventHubConsumerClient eventHubConsumerClient,
      SubscribeOptions? subscribeOptions) async {
    var jsonSubscribeOptions = "{}";
    if (subscribeOptions != null) {
      jsonSubscribeOptions =
          await _subscribeOptionsMapperService.toJson(subscribeOptions);
    }

    var javascriptTransactionId = Uuid().v4();
    var javascriptCode =
        "var eventHubConsumerClientInstance = flutterAzureEventHubs.getEventHubConsumerClientByKey('" +
            eventHubConsumerClient.id +
            "'); if (eventHubConsumerClientInstance != null) {" +
            "eventHubConsumerClientInstance.subscribe({ processEvents: function (receivedDataList, partitionContext) {" +
            "for (var index in receivedDataList) { " +
            "var base64IncomingEvent = btoa(JSON.stringify(" +
            "{ receivedEventData: { body: receivedDataList[index].body, " +
            "enqueuedTimeUtc: receivedDataList[index].enqueuedTimeUtc, " +
            "partitionKey: receivedDataList[index].partitionKey, " +
            "offset: receivedDataList[index].offset, " +
            "sequenceNumber: receivedDataList[index].sequenceNumber }, " +
            "partitionContext: { fullyQualifiedNamespace: partitionContext._context.fullyQualifiedNamespace, " +
            "eventHubName: partitionContext._context.eventHubName, " +
            "consumerGroup: partitionContext._context.consumerGroup, " +
            "partitionId: partitionContext._context.partitionId }}));" +
            "proxyInterop.postMessage('{\"id\":\"" +
            Uuid().v4() +
            "\",\"javascriptTransactionId\":\"" +
            javascriptTransactionId +
            "\",\"success\":true,\"result\":\"' + base64IncomingEvent + '\"}');" +
            "}}, processError: function(error) {" +
            "proxyInterop.postMessage('{\"id\":\"" +
            Uuid().v4() +
            "\",\"javascriptTransactionId\":\"" +
            javascriptTransactionId +
            "\",\"success\":false,\"result\":\"' + error + '\"}');" +
            "} }, " +
            jsonSubscribeOptions +
            "); } else {" +
            "proxyInterop.postMessage('{\"id\":\"" +
            Uuid().v4() +
            "\",\"javascriptTransactionId\":\"" +
            javascriptTransactionId +
            "\",\"success\":false,\"result\":\"ERROR: EventHubConsumerClient not found.\"}');" +
            "}";

    var javascriptTransaction =
        JavascriptTransaction(javascriptTransactionId, javascriptCode);
    return Future.value(javascriptTransaction);
  }
}
