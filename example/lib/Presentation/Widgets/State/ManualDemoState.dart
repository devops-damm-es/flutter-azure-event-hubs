import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventHubConsumerClient.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventHubProducerClient.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/IncomingEvent.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/Subscription.dart';

class ManualDemoState {
  static String eventHubName = "eventHubName";
  static EventHubProducerClient? eventHubProducerClient;
  static EventHubConsumerClient? eventHubConsumerClient;
  // ignore: close_sinks
  static StreamController<IncomingEvent>? incomingEventStreamController;
  static Subscription? subscription;

  static TextEditingController eventHubProducerController =
      TextEditingController();
  static TextEditingController eventHubConsumerController =
      TextEditingController();
  static ScrollController verticalScrollController =
      ScrollController(initialScrollOffset: 0);
  static ScrollController horizontalScrollController =
      ScrollController(initialScrollOffset: 0);
}
