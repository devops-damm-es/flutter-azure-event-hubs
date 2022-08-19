import 'package:flutter_azure_event_hubs/Domain/Entities/EventHubConsumerClient.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SubscribeOptions.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/Subscription.dart';

abstract class IEventHubConsumerClientRepositoryService {
  Future<JavascriptTransaction>
      getCreateEventHubConsumerClientJavascriptTransaction(
          EventHubConsumerClient eventHubConsumerClient);
  Future<JavascriptTransaction> getSubscribeJavascriptTransaction(
      EventHubConsumerClient eventHubConsumerClient,
      Subscription subscription,
      SubscribeOptions? subscribeOptions);
}
