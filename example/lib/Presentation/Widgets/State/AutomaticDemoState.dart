import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventHubConsumerClient.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventHubProducerClient.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/IncomingEvent.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/Subscription.dart';
import 'package:vertical_barchart/vertical-barchartmodel.dart';

class AutomaticDemoState {
  static String fromClientToServerEventHubName =
      "fromClientToServerEventHubName";
  static String fromServerToClientEventHubName =
      "fromServerToClientEventHubName";
  static EventHubProducerClient? eventHubProducerClient;
  static EventHubConsumerClient? eventHubConsumerClient;
  // ignore: close_sinks
  static StreamController<IncomingEvent>? incomingEventStreamController;
  static Subscription? subscription;

  static ScrollController verticalScrollController =
      ScrollController(initialScrollOffset: 0);
  static ScrollController horizontalScrollController =
      ScrollController(initialScrollOffset: 0);

  static TextEditingController textEditingController = TextEditingController();

  static String name = "";
  static bool isStarted = false;
  static bool isInitializing = false;
  static bool stopRequest = false;
  static List<VBarChartModel> vBarChartModelList =
      List<VBarChartModel>.empty(growable: true);
}
