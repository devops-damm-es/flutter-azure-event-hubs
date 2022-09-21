import 'dart:async';
import 'dart:typed_data';

import 'package:breakpoint/breakpoint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/AvroSerializer.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/AvroSerializerOptions.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/DeserializeOptions.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventData.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventPosition.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/IncomingEvent.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/MessageContent.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SchemaDescription.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SubscribeOptions.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/TokenCredentialOptions.dart';
import 'package:flutter_azure_event_hubs_example/globals.dart';

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
                controller: Globals.eventHubProducerController,
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
              controller: Globals.eventHubConsumerController,
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
      Globals.eventHubProducerClientApplicationService!
          .createEventHubProducerClient(
              Globals.connectionString, Globals.eventHubName)
          .then((eventHubProducerClient) {
        Globals.eventHubProducerController.text = DateTime.now().toString() +
            ": EventHubProducerClient created.\n" +
            Globals.eventHubProducerController.text;
        Globals.eventHubProducerClient = eventHubProducerClient;

        getAvroSerializer().then((avroSerializer) {
          Globals.avroSerializerApplicationService!
              .serialize(
                  avroSerializer,
                  "{\"id\":\"id_test\",\"sourceId\":\"sourceId_test\"}",
                  Globals.schemaDefinition)
              .then((messageContent) {
            Globals.eventHubProducerController.text =
                DateTime.now().toString() +
                    ": contentType: " +
                    messageContent.contentType +
                    " \n" +
                    Globals.eventHubProducerController.text;

            var eventDataList = List<EventData>.empty(growable: true);
            eventDataList.add(
                EventData(messageContent.data, messageContent.contentType));

            Globals.eventHubProducerClientApplicationService!
                .sendEventDataBatch(
                    Globals.eventHubProducerClient!, eventDataList)
                .then((_) {
              Globals.eventHubProducerController.text =
                  DateTime.now().toString() +
                      ": Send new events.\n" +
                      Globals.eventHubProducerController.text;

              Globals.eventHubProducerClientApplicationService!
                  .closeEventHubProducerClient(Globals.eventHubProducerClient!)
                  .then((_) {
                Globals.eventHubProducerController.text =
                    DateTime.now().toString() +
                        ": EventHubProducerClient closed.\n" +
                        Globals.eventHubProducerController.text;
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
        if (Globals.eventHubConsumerClient == null) {
          Globals.eventHubConsumerClientApplicationService!
              .createEventHubConsumerClient(Globals.consumerGroup,
                  Globals.connectionString, Globals.eventHubName)
              .then((eventHubConsumerClient) {
            Globals.eventHubConsumerClient = eventHubConsumerClient;
            Globals.eventHubConsumerController.text =
                DateTime.now().toString() +
                    ": EventHubConsumerClient created.\n" +
                    Globals.eventHubConsumerController.text;

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

                    if (event.receivedEventDataList.first.contentType != null) {
                      Globals.eventHubConsumerController.text =
                          DateTime.now().toString() +
                              ": ContentType: " +
                              event.receivedEventDataList.first.contentType! +
                              "\n" +
                              Globals.eventHubConsumerController.text;

                      getAvroSerializer().then((avroSerializer) {
                        Globals.avroSerializerApplicationService!
                            .deserialize(
                                avroSerializer,
                                new MessageContent(
                                    Uint8List.fromList(event
                                        .receivedEventDataList.first.body
                                        .cast<int>()),
                                    event.receivedEventDataList.first
                                        .contentType!),
                                deserializeOptions: new DeserializeOptions(
                                    Globals.schemaDefinition))
                            .then((jsonValue) {
                          Globals.eventHubConsumerController.text =
                              DateTime.now().toString() +
                                  ": jsonValue: " +
                                  jsonValue +
                                  "\n" +
                                  Globals.eventHubConsumerController.text;
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
              Globals.eventHubConsumerClientApplicationService!
                  .subscribe(Globals.eventHubConsumerClient!,
                      Globals.incomingEventStreamController!.sink,
                      subscribeOptions: SubscribeOptions(null, null,
                          EventPosition(0, null, null, null), null, null, null))
                  .then((subscription) {
                Globals.subscription = subscription;
                Globals.eventHubConsumerController.text =
                    DateTime.now().toString() +
                        ": Subscribe.\n" +
                        Globals.eventHubConsumerController.text;
              }).onError((error, stackTrace) {
                eventHubConsumerError(error);
              });
            } else {
              Globals.eventHubConsumerController.text =
                  DateTime.now().toString() +
                      ": Already subscribed.\n" +
                      Globals.eventHubConsumerController.text;
            }
          }).onError((error, stackTrace) {
            eventHubConsumerError(error);
          });
        } else {
          Globals.eventHubConsumerController.text = DateTime.now().toString() +
              ": EventHubConsumerClient already created.\n" +
              Globals.eventHubConsumerController.text;
        }
      } catch (error) {
        Globals.eventHubConsumerController.text = DateTime.now().toString() +
            ": ERROR: " +
            error.toString() +
            "\n" +
            Globals.eventHubConsumerController.text;
      }
    });
  }

  void _closeReceiveEventData() {
    setState(() {
      if (Globals.subscription != null) {
        Globals.eventHubConsumerClientApplicationService!
            .closeSubscription(Globals.subscription!)
            .then((value) {
          Globals.incomingEventStreamController!.close().then((value) {
            Globals.incomingEventStreamController = null;
            Globals.subscription = null;
            Globals.eventHubConsumerController.text =
                DateTime.now().toString() +
                    ": Subscription closed.\n" +
                    Globals.eventHubConsumerController.text;

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
                Globals.eventHubConsumerController.text =
                    DateTime.now().toString() +
                        ": EventHubConsumerClient closed.\n" +
                        Globals.eventHubConsumerController.text;
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
        Globals.eventHubConsumerController.text = DateTime.now().toString() +
            ": There is no subscription created.\n" +
            Globals.eventHubConsumerController.text;
      }
    });
  }

  Future<AvroSerializer> getAvroSerializer() async {
    if (Globals.avroSerializer == null) {
      var clientSecretCredential = await Globals
          .clientSecretCredentialApplicationService!
          .createClientSecretCredential(
              Globals.tenantId, Globals.clientId, Globals.clientSecret,
              tokenCredentialOptions:
                  new TokenCredentialOptions(Globals.authorityHost));

      var schemaRegistryClient = await Globals
          .schemaRegistryClientApplicationService!
          .createSchemaRegistryClient(
              Globals.fullyQualifiedNamespace, clientSecretCredential);

      var schemaDescription = SchemaDescription("groupschema1",
          "damm.lab.eventhubs.Order", "avro", Globals.schemaDefinition);

      Globals.avroSerializer = await Globals.avroSerializerApplicationService!
          .createAvroSerializer(schemaRegistryClient,
              avroSerializerOptions: new AvroSerializerOptions(
                  false, schemaDescription.groupName));
    }
    return Future.value(Globals.avroSerializer!);
  }

  void eventHubProducerError(dynamic error) {
    Globals.eventHubProducerController.text = DateTime.now().toString() +
        ": ERROR: " +
        error.toString() +
        "\n" +
        Globals.eventHubProducerController.text;
  }

  void eventHubConsumerError(dynamic error) {
    Globals.eventHubConsumerController.text = DateTime.now().toString() +
        ": ERROR: " +
        error.toString() +
        "\n" +
        Globals.eventHubConsumerController.text;
  }
}
