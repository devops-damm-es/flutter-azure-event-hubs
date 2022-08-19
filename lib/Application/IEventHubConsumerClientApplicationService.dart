import 'dart:async';

import 'package:flutter_azure_event_hubs/Domain/Entities/EventHubConsumerClient.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/IncomingEvent.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SubscribeOptions.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/Subscription.dart';

abstract class IEventHubConsumerClientApplicationService {
  Future<EventHubConsumerClient> createEventHubConsumerClient(
      String consumerGroup, String connectionString, String eventHubName);
  Future<Subscription> subscribe(EventHubConsumerClient eventHubConsumerClient,
      StreamSink<IncomingEvent> incomingEventStreamSink,
      {SubscribeOptions? subscribeOptions});
}
