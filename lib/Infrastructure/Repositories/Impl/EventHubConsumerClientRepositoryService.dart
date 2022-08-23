import 'package:flutter_azure_event_hubs/Domain/Entities/EventHubConsumerClient.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SubscribeOptions.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/Subscription.dart';
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
    var javascriptCode =
        "flutterAzureEventHubs.api.createEventHubConsumerClient('" +
            eventHubConsumerClient.id +
            "', '" +
            eventHubConsumerClient.consumerGroup +
            "', '" +
            eventHubConsumerClient.connectionString +
            "', '" +
            eventHubConsumerClient.eventHubName +
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
  Future<JavascriptTransaction> getSubscribeJavascriptTransaction(
      EventHubConsumerClient eventHubConsumerClient,
      Subscription subscription,
      SubscribeOptions? subscribeOptions) async {
    var jsonSubscribeOptions = "{}";
    if (subscribeOptions != null) {
      jsonSubscribeOptions =
          await _subscribeOptionsMapperService.toJson(subscribeOptions);
    }

    var javascriptTransactionId = Uuid().v4();
    var javascriptCode = "flutterAzureEventHubs.api.subscribe('" +
        eventHubConsumerClient.id +
        "', '" +
        subscription.id +
        "'," +
        jsonSubscribeOptions +
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
  Future<JavascriptTransaction> getCloseSubscriptionJavascriptTransaction(
      Subscription subscription) async {
    var javascriptTransactionId = Uuid().v4();
    var javascriptCode = "flutterAzureEventHubs.api.closeSubscription('" +
        subscription.id +
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
  Future<JavascriptTransaction>
      getCloseEventHubConsumerClientJavascriptTransaction(
          EventHubConsumerClient eventHubConsumerClient,
          Iterable<Subscription> subscriptionList) async {
    var subscriptionIdList = "[]";
    if (subscriptionList.isNotEmpty) {
      subscriptionIdList = "[";
      for (var subscription in subscriptionList) {
        subscriptionIdList += "'" + subscription.id + "',";
      }
      subscriptionIdList =
          subscriptionIdList.substring(0, subscriptionIdList.length - 1);
      subscriptionIdList += "]";
    }

    var javascriptTransactionId = Uuid().v4();
    var javascriptCode =
        "flutterAzureEventHubs.api.closeEventHubConsumerClient('" +
            eventHubConsumerClient.id +
            "', " +
            subscriptionIdList +
            ", '" +
            javascriptTransactionId +
            "', '" +
            Uuid().v4() +
            "');";

    var javascriptTransaction =
        JavascriptTransaction(javascriptTransactionId, javascriptCode);
    return Future.value(javascriptTransaction);
  }
}
