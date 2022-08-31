import 'dart:async';

import 'package:breakpoint/breakpoint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventData.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventPosition.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/IncomingEvent.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SubscribeOptions.dart';
import 'package:flutter_azure_event_hubs_example/globals.dart';
import 'package:uuid/uuid.dart';

class EventHubControl extends StatefulWidget {
  @override
  State<EventHubControl> createState() => _EventHubControlState();
}

class _EventHubControlState extends State<EventHubControl> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext layoutContext, BoxConstraints boxConstraints) {
      var width = boxConstraints.maxWidth;
      var height = boxConstraints.maxHeight;

      var widthBreakpoint = Breakpoint.fromConstraints(
          BoxConstraints(maxWidth: width, maxHeight: height));
      var breakpointMarginWidth = widthBreakpoint.gutters;
      var breakpointGutterWidth = widthBreakpoint.gutters;

      var breakpointColumnsWidth = (width -
              (((breakpointMarginWidth + breakpointGutterWidth) / 2) *
                  (widthBreakpoint.columns + 1))) /
          widthBreakpoint.columns;

      var buttonsInBottom = widthBreakpoint.window == WindowSize.xsmall ||
              widthBreakpoint.window == WindowSize.small
          ? true
          : false;

      var heightBreakpoint = Breakpoint.fromConstraints(
          BoxConstraints(maxWidth: height, maxHeight: width));
      var breakpointMarginHeight = heightBreakpoint.gutters;
      var breakpointGutterHeight = heightBreakpoint.gutters;

      var breakpointColumnsHeight = (height -
              (((breakpointMarginHeight + breakpointGutterHeight) / 2) *
                  (heightBreakpoint.columns + 1))) /
          heightBreakpoint.columns;

      var eventHubProducerConsumerTextFieldWidth = buttonsInBottom
          ? (breakpointColumnsWidth * widthBreakpoint.columns) +
              (breakpointGutterWidth * (widthBreakpoint.columns - 1))
          : (breakpointColumnsWidth * (widthBreakpoint.columns - 2)) +
              (breakpointGutterWidth * (widthBreakpoint.columns - 3));

      var eventHubProducerConsumerTextFieldHeight = buttonsInBottom
          ? (breakpointColumnsHeight * ((heightBreakpoint.columns / 2) - 1)) +
              breakpointGutterHeight * ((heightBreakpoint.columns / 2) - 2)
          : (breakpointColumnsHeight * (heightBreakpoint.columns / 2)) +
              breakpointGutterHeight * ((heightBreakpoint.columns / 2) - 1);

      var eventHubProducerConsumerButtonsContainerWidth = buttonsInBottom
          ? (breakpointColumnsWidth * widthBreakpoint.columns) +
              (breakpointGutterWidth * (widthBreakpoint.columns - 1))
          : (breakpointColumnsWidth * 2) + breakpointGutterWidth;

      var eventHubProducerConsumerButtonsContainerHeight = buttonsInBottom
          ? breakpointColumnsHeight
          : (breakpointColumnsHeight * (heightBreakpoint.columns / 2)) +
              breakpointGutterHeight * ((heightBreakpoint.columns / 2) - 1);

      var eventHubProducerWidgets = <Widget>[
        Container(
            width: eventHubProducerConsumerTextFieldWidth,
            height: eventHubProducerConsumerTextFieldHeight,
            color: Colors.yellow,
            child: TextField(
                decoration: InputDecoration(
                    labelText: 'Events sended:', border: OutlineInputBorder()),
                controller: Globals.eventHubProducerController,
                keyboardType: TextInputType.multiline,
                textAlignVertical: TextAlignVertical.top,
                expands: true,
                readOnly: true,
                maxLines: null)),
        Container(
            width: buttonsInBottom ? 10 : breakpointGutterWidth,
            height: buttonsInBottom ? breakpointGutterHeight : 10,
            color: Colors.pink),
        Container(
          width: eventHubProducerConsumerButtonsContainerWidth,
          height: eventHubProducerConsumerButtonsContainerHeight,
          color: Colors.amber,
          child: ElevatedButton(
            onPressed: _sendEventDataBatch,
            child: Text("Send Event Data"),
          ),
        )
      ];

      var eventHubConsumerWidgets = <Widget>[
        Container(
          width: eventHubProducerConsumerTextFieldWidth,
          height: eventHubProducerConsumerTextFieldHeight,
          color: Colors.yellow,
          child: TextField(
              decoration: InputDecoration(
                  labelText: 'Events received:', border: OutlineInputBorder()),
              controller: Globals.eventHubConsumerController,
              keyboardType: TextInputType.multiline,
              textAlignVertical: TextAlignVertical.top,
              expands: true,
              readOnly: true,
              maxLines: null),
        ),
        Container(
            width: buttonsInBottom ? 10 : breakpointGutterWidth,
            height: buttonsInBottom ? breakpointGutterHeight : 10,
            color: Colors.pink),
        Container(
            width: eventHubProducerConsumerButtonsContainerWidth,
            height: eventHubProducerConsumerButtonsContainerHeight,
            color: Colors.amber,
            child: Row(
              children: [
                ElevatedButton(
                    onPressed: _createEventHubConsumerClient,
                    child: Text("Create Event Hub Consumer Client")),
                ElevatedButton(onPressed: _subscribe, child: Text("Subscribe")),
                ElevatedButton(
                    onPressed: _closeSubscription,
                    child: Text("Close Subscription")),
                ElevatedButton(
                    onPressed: _closeEventHubConsumerClient,
                    child: Text("Close Event Hub Consumer Client"))
              ],
            ))
      ];

      return Scrollbar(
          thumbVisibility: true,
          trackVisibility: true,
          controller: Globals.verticalScrollController,
          child: Scrollbar(
              thumbVisibility: true,
              trackVisibility: true,
              notificationPredicate: (notificationPredicate) =>
                  notificationPredicate.depth == 1,
              controller: Globals.horizontalScrollController,
              child: SingleChildScrollView(
                  controller: Globals.verticalScrollController,
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                      controller: Globals.horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      child: Container(
                          width: width,
                          height: height,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    width: 10,
                                    height: breakpointMarginHeight,
                                    color: Colors.pink),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          width: breakpointMarginWidth,
                                          height: 10,
                                          color: Colors.pink),
                                      buttonsInBottom
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: eventHubProducerWidgets)
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children:
                                                  eventHubProducerWidgets),
                                      Container(
                                          width: breakpointMarginWidth,
                                          height: 10,
                                          color: Colors.pink),
                                    ]),
                                Container(
                                    width: 10,
                                    height: breakpointGutterHeight,
                                    color: Colors.pink),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          width: breakpointMarginWidth,
                                          height: 10,
                                          color: Colors.pink),
                                      buttonsInBottom
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: eventHubConsumerWidgets)
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children:
                                                  eventHubConsumerWidgets),
                                      Container(
                                          width: breakpointMarginWidth,
                                          height: 10,
                                          color: Colors.pink)
                                    ]),
                                Container(
                                    width: 10,
                                    height: breakpointMarginHeight,
                                    color: Colors.pink)
                              ]))))));
    });
  }

  void _sendEventDataBatch() {
    setState(() {
      Globals.eventHubProducerClientApplicationService!
          .createEventHubProducerClient(
              Globals.connectionString, Globals.eventHubName)
          .then((value) {
        Globals.eventHubProducerController.text = DateTime.now().toString() +
            ": EventHubProducerClient created.\n" +
            Globals.eventHubProducerController.text;
        Globals.eventHubProducerClient = value;

        var eventDataList = List<EventData>.empty(growable: true);
        eventDataList.add(EventData(Uuid().v4()));
        eventDataList.add(EventData(1));
        eventDataList.add(EventData(DateTime.now().toUtc().toString()));

        Globals.eventHubProducerClientApplicationService!
            .sendEventDataBatch(Globals.eventHubProducerClient!, eventDataList)
            .then((value) {
          Globals.eventHubProducerController.text = DateTime.now().toString() +
              ": Send new events.\n" +
              Globals.eventHubProducerController.text;
          Globals.eventHubProducerClientApplicationService!
              .closeEventHubProducerClient(Globals.eventHubProducerClient!)
              .then((value) {
            Globals.eventHubProducerController.text =
                DateTime.now().toString() +
                    ": EventHubProducerClient closed.\n" +
                    Globals.eventHubProducerController.text;
          });
        });
      });
    });
  }

  void _createEventHubConsumerClient() {
    setState(() {
      if (Globals.eventHubConsumerClient == null) {
        Globals.eventHubConsumerClientApplicationService!
            .createEventHubConsumerClient(Globals.consumerGroup,
                Globals.connectionString, Globals.eventHubName)
            .then((value) {
          Globals.eventHubConsumerClient = value;
          Globals.eventHubConsumerController.text = DateTime.now().toString() +
              ": EventHubConsumerClient created.\n" +
              Globals.eventHubConsumerController.text;
        });
      } else {
        Globals.eventHubConsumerController.text = DateTime.now().toString() +
            ": EventHubConsumerClient already created.\n" +
            Globals.eventHubConsumerController.text;
      }
    });
  }

  void _subscribe() {
    setState(() {
      if (Globals.incomingEventStreamController == null) {
        Globals.incomingEventStreamController =
            StreamController<IncomingEvent>();
        Globals.incomingEventStreamController!.stream.listen((event) {
          setState(() {
            if (event.receivedEventDataList.isNotEmpty) {
              Globals.eventHubConsumerController.text =
                  DateTime.now().toString() +
                      ": Receive new event: " +
                      event.receivedEventDataList.first.body.toString() +
                      "\n" +
                      Globals.eventHubConsumerController.text;
            }
          });
        });
        var subscribeOptions = SubscribeOptions(
            null, null, EventPosition(0, null, null, null), null, null, null);
        Globals.eventHubConsumerClientApplicationService!
            .subscribe(Globals.eventHubConsumerClient!,
                Globals.incomingEventStreamController!.sink,
                subscribeOptions: subscribeOptions)
            .then((value) {
          Globals.subscription = value;
          Globals.eventHubConsumerController.text = DateTime.now().toString() +
              ": Subscribe.\n" +
              Globals.eventHubConsumerController.text;
        });
      } else {
        Globals.eventHubConsumerController.text = DateTime.now().toString() +
            ": Already subscribed.\n" +
            Globals.eventHubConsumerController.text;
      }
    });
  }

  void _closeSubscription() {
    setState(() {
      Globals.eventHubConsumerClientApplicationService!
          .closeSubscription(Globals.subscription!)
          .then((value) {
        Globals.incomingEventStreamController!.close().then((value) {
          Globals.incomingEventStreamController = null;
          Globals.subscription = null;
          Globals.eventHubConsumerController.text = DateTime.now().toString() +
              ": Subscription closed.\n" +
              Globals.eventHubConsumerController.text;
        });
      });
    });
  }

  void _closeEventHubConsumerClient() {
    setState(() {
      Globals.eventHubConsumerClientApplicationService!
          .closeEventHubConsumerClient(Globals.eventHubConsumerClient!)
          .then((value) {
        if (Globals.incomingEventStreamController != null) {
          Globals.incomingEventStreamController!.close().then((value) {
            Globals.incomingEventStreamController = null;
            Globals.subscription = null;
            Globals.eventHubConsumerClient = null;
            Globals.eventHubConsumerController.text =
                DateTime.now().toString() +
                    ": EventHubConsumerClient closed.\n" +
                    Globals.eventHubConsumerController.text;
          });
        } else {
          Globals.eventHubConsumerClient = null;
          Globals.eventHubConsumerController.text = DateTime.now().toString() +
              ": EventHubConsumerClient closed.\n" +
              Globals.eventHubConsumerController.text;
        }
      });
    });
  }
}