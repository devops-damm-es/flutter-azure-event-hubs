import 'package:flutter_azure_event_hubs/Domain/Entities/EventHubConsumerClient.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IEventHubConsumerClientRepositoryService.dart';
import 'package:uuid/uuid.dart';

class EventHubConsumerClientRepositoryService
    extends IEventHubConsumerClientRepositoryService {
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
}
