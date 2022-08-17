import 'package:flutter_azure_event_hubs/Domain/Entities/EventHubConsumerClient.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';

abstract class IEventHubConsumerClientRepositoryService {
  Future<JavascriptTransaction>
      getCreateEventHubConsumerClientJavascriptTransaction(
          EventHubConsumerClient eventHubConsumerClient);
}
