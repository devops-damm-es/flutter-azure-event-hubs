import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_azure_event_hubs/Application/IEventHubConsumerClientApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/IEventHubProducerClientApplicationService.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventHubConsumerClient.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventHubProducerClient.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/IncomingEvent.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/Subscription.dart';
import 'package:google_fonts/google_fonts.dart';

class Globals {
  static IEventHubProducerClientApplicationService?
      eventHubProducerClientApplicationService;
  static IEventHubConsumerClientApplicationService?
      eventHubConsumerClientApplicationService;
  static String consumerGroup = "\$default";
  static String connectionString = "connectionString";
  static String eventHubName = "eventHubName";
  static EventHubProducerClient? eventHubProducerClient;
  static EventHubConsumerClient? eventHubConsumerClient;
  // ignore: close_sinks
  static StreamController<IncomingEvent>? incomingEventStreamController;
  static Subscription? subscription;

  static int bottomNavigationBarSelectedIndex = 0;
  static TextStyle buttonTextStyle = GoogleFonts.roboto(
      fontWeight: FontWeight.w500, fontSize: 14.0, letterSpacing: 1.25);

  static TextEditingController eventHubProducerController =
      TextEditingController();
  static TextEditingController eventHubConsumerController =
      TextEditingController();
  static ScrollController verticalScrollController =
      ScrollController(initialScrollOffset: 0);
  static ScrollController horizontalScrollController =
      ScrollController(initialScrollOffset: 0);
}
