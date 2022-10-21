import 'dart:async';
import 'dart:typed_data';

import 'package:breakpoint/breakpoint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/DeserializeOptions.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventData.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventPosition.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/IncomingEvent.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/MessageContent.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SubscribeOptions.dart';
import 'package:flutter_azure_event_hubs_example/Configuration.dart';
import 'package:flutter_azure_event_hubs_example/Presentation/Widgets/State/ManualDemoState.dart';

class ManualDemoControl extends StatefulWidget {
  @override
  State<ManualDemoControl> createState() => _ManualDemoControlState();
}

class _ManualDemoControlState extends State<ManualDemoControl> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext layoutContext, BoxConstraints boxConstraints) {
      var width = boxConstraints.maxWidth;
      if (width < 360) {
        width = 360;
      }

      var height = boxConstraints.maxHeight;
      if (height < 480) {
        height = 480;
      }

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

      var eventHubProducerButtonsWidth = buttonsInBottom
          ? (breakpointColumnsWidth * (widthBreakpoint.columns / 2)) -
              breakpointGutterHeight
          : eventHubProducerConsumerButtonsContainerWidth;

      var eventHubProducerButtonsWidgets = <Widget>[
        Container(
            width: eventHubProducerButtonsWidth,
            height: 36,
            child: ElevatedButton(
                onPressed: _sendEventDataBatch, child: Text("SEND")))
      ];

      var eventHubProducerWidgets = <Widget>[
        Container(
            width: eventHubProducerConsumerTextFieldWidth,
            height: eventHubProducerConsumerTextFieldHeight,
            child: TextField(
                decoration: InputDecoration(
                    labelText: 'Events sended:', border: OutlineInputBorder()),
                controller: ManualDemoState.eventHubProducerController,
                keyboardType: TextInputType.multiline,
                textAlignVertical: TextAlignVertical.top,
                expands: true,
                readOnly: true,
                maxLines: null)),
        Container(
            width: buttonsInBottom ? 10 : breakpointGutterWidth,
            height: buttonsInBottom ? breakpointGutterHeight : 10),
        Container(
            width: eventHubProducerConsumerButtonsContainerWidth,
            height: eventHubProducerConsumerButtonsContainerHeight,
            child: buttonsInBottom
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: eventHubProducerButtonsWidgets,
                  )
                : Column(
                    children: eventHubProducerButtonsWidgets,
                  ))
      ];

      var eventHubConsumerButtonsSpacing =
          buttonsInBottom ? breakpointGutterWidth : breakpointGutterHeight;

      var eventHubConsumerButtonsWidgets = <Widget>[
        Container(
            width: eventHubProducerButtonsWidth,
            height: 36,
            child: ElevatedButton(
                onPressed: _receiveEventData, child: Text("RECEIVE"))),
        Container(
            width: eventHubConsumerButtonsSpacing,
            height: eventHubConsumerButtonsSpacing),
        Container(
            width: eventHubProducerButtonsWidth,
            height: 36,
            child: ElevatedButton(
                onPressed: _closeReceiveEventData, child: Text("CLOSE")))
      ];

      var eventHubConsumerWidgets = <Widget>[
        Container(
          width: eventHubProducerConsumerTextFieldWidth,
          height: eventHubProducerConsumerTextFieldHeight,
          child: TextField(
              decoration: InputDecoration(
                  labelText: 'Events received:', border: OutlineInputBorder()),
              controller: ManualDemoState.eventHubConsumerController,
              keyboardType: TextInputType.multiline,
              textAlignVertical: TextAlignVertical.top,
              expands: true,
              readOnly: true,
              maxLines: null),
        ),
        Container(
            width: buttonsInBottom ? 10 : breakpointGutterWidth,
            height: buttonsInBottom ? breakpointGutterHeight : 10),
        Container(
            width: eventHubProducerConsumerButtonsContainerWidth,
            height: eventHubProducerConsumerButtonsContainerHeight,
            child: buttonsInBottom
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: eventHubConsumerButtonsWidgets,
                  )
                : Column(
                    children: eventHubConsumerButtonsWidgets,
                  ))
      ];

      return Scrollbar(
          thumbVisibility: true,
          trackVisibility: true,
          controller: ManualDemoState.verticalScrollController,
          child: Scrollbar(
              thumbVisibility: true,
              trackVisibility: true,
              notificationPredicate: (notificationPredicate) =>
                  notificationPredicate.depth == 1,
              controller: ManualDemoState.horizontalScrollController,
              child: SingleChildScrollView(
                  controller: ManualDemoState.verticalScrollController,
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                      controller: ManualDemoState.horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      child: Container(
                          width: width,
                          height: height,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    width: 10, height: breakpointMarginHeight),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          width: breakpointMarginWidth,
                                          height: 10),
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
                                          height: 10)
                                    ]),
                                Container(
                                    width: 10, height: breakpointGutterHeight),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          width: breakpointMarginWidth,
                                          height: 10),
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
                                          height: 10)
                                    ]),
                                Container(
                                    width: 10, height: breakpointMarginHeight)
                              ]))))));
    });
  }

  void _sendEventDataBatch() {
    setState(() {
      Configuration.eventHubProducerClientApplicationService!
          .createEventHubProducerClient(
              Configuration.connectionString, ManualDemoState.eventHubName)
          .then((eventHubProducerClient) {
        ManualDemoState.eventHubProducerController.text =
            DateTime.now().toString() +
                ": EventHubProducerClient created.\n" +
                ManualDemoState.eventHubProducerController.text;
        ManualDemoState.eventHubProducerClient = eventHubProducerClient;

        Configuration.getAvroSerializer().then((avroSerializer) {
          Configuration.avroSerializerApplicationService!
              .serialize(
                  avroSerializer,
                  "{\"id\":\"id_test\",\"sourceId\":\"sourceId_test\"}",
                  Configuration.schemaDefinition)
              .then((messageContent) {
            ManualDemoState.eventHubProducerController.text =
                DateTime.now().toString() +
                    ": contentType: " +
                    messageContent.contentType +
                    " \n" +
                    ManualDemoState.eventHubProducerController.text;

            var eventDataList = List<EventData>.empty(growable: true);
            eventDataList.add(
                EventData(messageContent.data, messageContent.contentType));

            Configuration.eventHubProducerClientApplicationService!
                .sendEventDataBatch(
                    ManualDemoState.eventHubProducerClient!, eventDataList)
                .then((_) {
              ManualDemoState.eventHubProducerController.text =
                  DateTime.now().toString() +
                      ": Send new events.\n" +
                      ManualDemoState.eventHubProducerController.text;

              Configuration.eventHubProducerClientApplicationService!
                  .closeEventHubProducerClient(
                      ManualDemoState.eventHubProducerClient!)
                  .then((_) {
                ManualDemoState.eventHubProducerController.text =
                    DateTime.now().toString() +
                        ": EventHubProducerClient closed.\n" +
                        ManualDemoState.eventHubProducerController.text;
              }).onError((error, stackTrace) {
                eventHubProducerError(error);
              });
            }).onError((error, stackTrace) {
              eventHubProducerError(error);
            });
          }).onError((error, stackTrace) {
            eventHubProducerError(error);
          });
        }).onError((error, stackTrace) {
          eventHubProducerError(error);
        });
      }).onError((error, stackTrace) {
        eventHubProducerError(error);
      });
    });
  }

  void _receiveEventData() {
    setState(() {
      try {
        if (ManualDemoState.eventHubConsumerClient == null) {
          Configuration.eventHubConsumerClientApplicationService!
              .createEventHubConsumerClient(Configuration.consumerGroup,
                  Configuration.connectionString, ManualDemoState.eventHubName)
              .then((eventHubConsumerClient) {
            ManualDemoState.eventHubConsumerClient = eventHubConsumerClient;
            ManualDemoState.eventHubConsumerController.text =
                DateTime.now().toString() +
                    ": EventHubConsumerClient created.\n" +
                    ManualDemoState.eventHubConsumerController.text;

            if (ManualDemoState.incomingEventStreamController == null) {
              ManualDemoState.incomingEventStreamController =
                  StreamController<IncomingEvent>();
              ManualDemoState.incomingEventStreamController!.stream
                  .listen((event) {
                setState(() {
                  if (event.receivedEventDataList.isNotEmpty) {
                    ManualDemoState.eventHubConsumerController.text =
                        DateTime.now().toString() +
                            ": Receive new event: " +
                            event.receivedEventDataList.first.body.toString() +
                            "\n" +
                            ManualDemoState.eventHubConsumerController.text;

                    if (event.receivedEventDataList.first.contentType != null) {
                      ManualDemoState.eventHubConsumerController.text =
                          DateTime.now().toString() +
                              ": ContentType: " +
                              event.receivedEventDataList.first.contentType! +
                              "\n" +
                              ManualDemoState.eventHubConsumerController.text;

                      Configuration.getAvroSerializer().then((avroSerializer) {
                        Configuration.avroSerializerApplicationService!
                            .deserialize(
                                avroSerializer,
                                new MessageContent(
                                    Uint8List.fromList(event
                                        .receivedEventDataList.first.body
                                        .cast<int>()),
                                    event.receivedEventDataList.first
                                        .contentType!),
                                deserializeOptions: new DeserializeOptions(
                                    Configuration.schemaDefinition))
                            .then((jsonValue) {
                          ManualDemoState.eventHubConsumerController.text =
                              DateTime.now().toString() +
                                  ": jsonValue: " +
                                  jsonValue +
                                  "\n" +
                                  ManualDemoState
                                      .eventHubConsumerController.text;
                        }).onError((error, stackTrace) {
                          eventHubConsumerError(error);
                        });
                      }).onError((error, stackTrace) {
                        eventHubConsumerError(error);
                      });
                    }
                  }
                });
              });
              Configuration.eventHubConsumerClientApplicationService!
                  .subscribe(ManualDemoState.eventHubConsumerClient!,
                      ManualDemoState.incomingEventStreamController!.sink,
                      subscribeOptions: SubscribeOptions(null, null,
                          EventPosition(0, null, null, null), null, null, null))
                  .then((subscription) {
                ManualDemoState.subscription = subscription;
                ManualDemoState.eventHubConsumerController.text =
                    DateTime.now().toString() +
                        ": Subscribe.\n" +
                        ManualDemoState.eventHubConsumerController.text;
              }).onError((error, stackTrace) {
                eventHubConsumerError(error);
              });
            } else {
              ManualDemoState.eventHubConsumerController.text =
                  DateTime.now().toString() +
                      ": Already subscribed.\n" +
                      ManualDemoState.eventHubConsumerController.text;
            }
          }).onError((error, stackTrace) {
            eventHubConsumerError(error);
          });
        } else {
          ManualDemoState.eventHubConsumerController.text =
              DateTime.now().toString() +
                  ": EventHubConsumerClient already created.\n" +
                  ManualDemoState.eventHubConsumerController.text;
        }
      } catch (error) {
        ManualDemoState.eventHubConsumerController.text =
            DateTime.now().toString() +
                ": ERROR: " +
                error.toString() +
                "\n" +
                ManualDemoState.eventHubConsumerController.text;
      }
    });
  }

  void _closeReceiveEventData() {
    setState(() {
      if (ManualDemoState.subscription != null) {
        Configuration.eventHubConsumerClientApplicationService!
            .closeSubscription(ManualDemoState.subscription!)
            .then((value) {
          ManualDemoState.incomingEventStreamController!.close().then((value) {
            ManualDemoState.incomingEventStreamController = null;
            ManualDemoState.subscription = null;
            ManualDemoState.eventHubConsumerController.text =
                DateTime.now().toString() +
                    ": Subscription closed.\n" +
                    ManualDemoState.eventHubConsumerController.text;

            Configuration.eventHubConsumerClientApplicationService!
                .closeEventHubConsumerClient(
                    ManualDemoState.eventHubConsumerClient!)
                .then((value) {
              if (ManualDemoState.incomingEventStreamController != null) {
                ManualDemoState.incomingEventStreamController!
                    .close()
                    .then((value) {
                  ManualDemoState.incomingEventStreamController = null;
                  ManualDemoState.subscription = null;
                  ManualDemoState.eventHubConsumerClient = null;
                  ManualDemoState.eventHubConsumerController.text =
                      DateTime.now().toString() +
                          ": EventHubConsumerClient closed.\n" +
                          ManualDemoState.eventHubConsumerController.text;
                });
              } else {
                ManualDemoState.eventHubConsumerClient = null;
                ManualDemoState.eventHubConsumerController.text =
                    DateTime.now().toString() +
                        ": EventHubConsumerClient closed.\n" +
                        ManualDemoState.eventHubConsumerController.text;
              }
            }).onError((error, stackTrace) {
              eventHubConsumerError(error);
            });
          }).onError((error, stackTrace) {
            eventHubConsumerError(error);
          });
        }).onError((error, stackTrace) {
          eventHubConsumerError(error);
        });
      } else {
        ManualDemoState.eventHubConsumerController.text =
            DateTime.now().toString() +
                ": There is no subscription created.\n" +
                ManualDemoState.eventHubConsumerController.text;
      }
    });
  }

  void eventHubProducerError(dynamic error) {
    ManualDemoState.eventHubProducerController.text =
        DateTime.now().toString() +
            ": ERROR: " +
            error.toString() +
            "\n" +
            ManualDemoState.eventHubProducerController.text;
  }

  void eventHubConsumerError(dynamic error) {
    ManualDemoState.eventHubConsumerController.text =
        DateTime.now().toString() +
            ": ERROR: " +
            error.toString() +
            "\n" +
            ManualDemoState.eventHubConsumerController.text;
  }
}
