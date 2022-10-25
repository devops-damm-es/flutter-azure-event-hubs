import 'dart:async';
import 'dart:typed_data';

import 'package:breakpoint/breakpoint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/AvroSerializer.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/DeserializeOptions.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventData.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventPosition.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/IncomingEvent.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/MessageContent.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SubscribeOptions.dart';
import 'package:flutter_azure_event_hubs_example/Configuration.dart';
import 'package:flutter_azure_event_hubs_example/Domain/Entities/Order.dart';
import 'package:flutter_azure_event_hubs_example/Presentation/Widgets/State/AutomaticDemoState.dart';
import 'package:uuid/uuid.dart';
import 'package:vertical_barchart/vertical-barchart.dart';
import 'package:vertical_barchart/vertical-barchartmodel.dart';
import 'package:vertical_barchart/vertical-legend.dart';
import 'package:flinq/flinq.dart';
import 'package:wakelock/wakelock.dart';

class AutomaticDemoControl extends StatefulWidget {
  @override
  State<AutomaticDemoControl> createState() => _AutomaticDemoControlState();
}

class _AutomaticDemoControlState extends State<AutomaticDemoControl> {
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

      var eventHubProducerTextFieldWidth = buttonsInBottom
          ? (breakpointColumnsWidth * widthBreakpoint.columns) +
              (breakpointGutterWidth * (widthBreakpoint.columns - 1))
          : (breakpointColumnsWidth * (widthBreakpoint.columns - 2)) +
              (breakpointGutterWidth * (widthBreakpoint.columns - 3));

      var eventHubProducerTextFieldHeight = breakpointColumnsHeight;

      var eventHubConsumerWidth =
          (breakpointColumnsWidth * widthBreakpoint.columns) +
              (breakpointGutterWidth * (widthBreakpoint.columns - 1));

      var eventHubConsumerHeight = buttonsInBottom
          ? (breakpointColumnsHeight * (heightBreakpoint.columns - 2)) +
              (breakpointGutterHeight * (heightBreakpoint.columns - 3))
          : (breakpointColumnsHeight * (heightBreakpoint.columns - 1)) +
              (breakpointGutterHeight * (heightBreakpoint.columns - 2));

      var eventHubProducerConsumerButtonsContainerWidth = buttonsInBottom
          ? (breakpointColumnsWidth * widthBreakpoint.columns) +
              (breakpointGutterWidth * (widthBreakpoint.columns - 1))
          : (breakpointColumnsWidth * 2) + breakpointGutterWidth;

      var eventHubProducerConsumerButtonsContainerHeight =
          breakpointColumnsHeight;

      var eventHubProducerButtonsWidth = buttonsInBottom
          ? (breakpointColumnsWidth * (widthBreakpoint.columns / 2)) -
              breakpointGutterHeight
          : eventHubProducerConsumerButtonsContainerWidth;

      var eventHubProducerButtonsWidgets = <Widget>[
        Container(
            width: eventHubProducerButtonsWidth,
            height: 36,
            child: ElevatedButton(
                onPressed: AutomaticDemoState.name.length > 0 &&
                        AutomaticDemoState.isInitializing == false &&
                        AutomaticDemoState.stopRequest == false
                    ? _toggleAutomaticDemo
                    : null,
                child: Text(AutomaticDemoState.isStarted
                    ? AutomaticDemoState.stopRequest
                        ? "STOPPING..."
                        : "STOP"
                    : AutomaticDemoState.isInitializing
                        ? "INITIALIZING..."
                        : "START")))
      ];

      var eventHubProducerWidgets = <Widget>[
        Container(
            width: eventHubProducerTextFieldWidth,
            height: eventHubProducerTextFieldHeight,
            child: TextField(
                decoration: InputDecoration(
                    labelText: 'Name:',
                    counterText: "",
                    border: OutlineInputBorder()),
                controller: AutomaticDemoState.textEditingController,
                onChanged: (value) {
                  setState(() {
                    AutomaticDemoState.name =
                        AutomaticDemoState.textEditingController.text.trim();
                  });
                },
                keyboardType: TextInputType.name,
                textAlignVertical: TextAlignVertical.top,
                readOnly: AutomaticDemoState.isStarted ? true : false,
                maxLength: 100)),
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

      var eventHubConsumerWidgets = <Widget>[
        Container(
            width: eventHubConsumerWidth,
            height: eventHubConsumerHeight,
            child: Card(
                child: VerticalBarchart(
                    maxX: AutomaticDemoState.maxMessagesSecond,
                    data: AutomaticDemoState.vBarChartModelList,
                    showLegend: true,
                    showBackdrop: true,
                    background: Colors.transparent,
                    barStyle: BarStyle.CIRCLE,
                    alwaysShowDescription: true,
                    legend: [
                  Vlegend(
                    isSquare: false,
                    color: Theme.of(context).primaryColor,
                    text: "Messages / Second",
                  )
                ])))
      ];

      return Scrollbar(
          thumbVisibility: true,
          trackVisibility: true,
          controller: AutomaticDemoState.verticalScrollController,
          child: Scrollbar(
              thumbVisibility: true,
              trackVisibility: true,
              notificationPredicate: (notificationPredicate) =>
                  notificationPredicate.depth == 1,
              controller: AutomaticDemoState.horizontalScrollController,
              child: SingleChildScrollView(
                  controller: AutomaticDemoState.verticalScrollController,
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                      controller: AutomaticDemoState.horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      child: Container(
                          width: width,
                          height: height,
                          child: Stack(children: [
                            AutomaticDemoState.isInitializing ||
                                    AutomaticDemoState.stopRequest
                                ? LinearProgressIndicator()
                                : Container(),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      width: 10,
                                      height: breakpointMarginHeight),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            width: breakpointMarginWidth,
                                            height: 10),
                                        buttonsInBottom
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children:
                                                    eventHubProducerWidgets)
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
                                      width: 10,
                                      height: breakpointGutterHeight),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            width: breakpointMarginWidth,
                                            height: 10),
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: eventHubConsumerWidgets),
                                        Container(
                                            width: breakpointMarginWidth,
                                            height: 10)
                                      ]),
                                  Container(
                                      width: 10, height: breakpointMarginHeight)
                                ])
                          ]))))));
    });
  }

  void _toggleAutomaticDemo() {
    setState(() {
      if (AutomaticDemoState.isStarted == false) {
        _startAutomaticDemo();
      } else {
        _stopAutomaticDemo();
      }
    });
  }

  void _startAutomaticDemo() {
    Wakelock.enable();
    AutomaticDemoState.isInitializing = true;
    Configuration.eventHubProducerClientApplicationService!
        .createEventHubProducerClient(Configuration.connectionString,
            AutomaticDemoState.fromClientToServerEventHubName)
        .then((eventHubProducerClient) {
      setState(() {
        AutomaticDemoState.eventHubProducerClient = eventHubProducerClient;

        Configuration.eventHubConsumerClientApplicationService!
            .createEventHubConsumerClient(
                Configuration.consumerGroup,
                Configuration.connectionString,
                AutomaticDemoState.fromServerToClientEventHubName)
            .then((eventHubConsumerClient) {
          setState(() {
            AutomaticDemoState.eventHubConsumerClient = eventHubConsumerClient;

            Configuration.getAvroSerializer().then((avroSerializer) {
              setState(() {
                _sendEventDataBatch(avroSerializer);
                _incomingEventData(avroSerializer);
                Future.delayed(Duration(seconds: 1)).then((_) {
                  _refreshVerticalBarchart();
                });
              });
            });
          });
        });
      });
    });
  }

  void _stopAutomaticDemo() {
    AutomaticDemoState.stopRequest = true;
  }

  void _sendEventDataBatch(AvroSerializer avroSerializer) {
    Configuration.orderMapperService!
        .toJson(Order(Uuid().v4(), AutomaticDemoState.name))
        .then((jsonOrder) {
      Configuration.avroSerializerApplicationService!
          .serialize(avroSerializer, jsonOrder, Configuration.schemaDefinition)
          .then((messageContent) {
        setState(() {
          var eventDataList = List<EventData>.empty(growable: true);
          eventDataList
              .add(EventData(messageContent.data, messageContent.contentType));

          Configuration.eventHubProducerClientApplicationService!
              .sendEventDataBatch(
                  AutomaticDemoState.eventHubProducerClient!, eventDataList)
              .then((_) {
            setState(() {
              if (AutomaticDemoState.stopRequest == false) {
                AutomaticDemoState.isInitializing = false;
                AutomaticDemoState.isStarted = true;
                _sendEventDataBatch(avroSerializer);
              } else {
                Configuration.eventHubProducerClientApplicationService!
                    .closeEventHubProducerClient(
                        AutomaticDemoState.eventHubProducerClient!)
                    .then((_) {
                  setState(() {
                    AutomaticDemoState.eventHubProducerClient = null;
                    AutomaticDemoState.isStarted = false;
                    AutomaticDemoState.stopRequest = false;
                    Wakelock.disable();
                  });
                });
              }
            });
          });
        });
      });
    });
  }

  void _incomingEventData(AvroSerializer avroSerializer) {
    AutomaticDemoState.incomingEventStreamController =
        StreamController<IncomingEvent>();
    AutomaticDemoState.incomingEventStreamController!.stream.listen((event) {
      if (event.receivedEventDataList.isNotEmpty) {
        for (var receivedEventData in event.receivedEventDataList) {
          AutomaticDemoState.offset = receivedEventData.offset;
          Configuration.avroSerializerApplicationService!
              .deserialize(
                  avroSerializer,
                  new MessageContent(
                      Uint8List.fromList(receivedEventData.body.cast<int>()),
                      receivedEventData.contentType!),
                  deserializeOptions:
                      new DeserializeOptions(Configuration.schemaDefinition))
              .then((jsonOrder) {
            Configuration.orderMapperService!.fromJson(jsonOrder).then((order) {
              AutomaticDemoState.orderList.add(order);
            });
          });
        }
      }
    });
    Configuration.eventHubConsumerClientApplicationService!
        .subscribe(AutomaticDemoState.eventHubConsumerClient!,
            AutomaticDemoState.incomingEventStreamController!.sink,
            subscribeOptions: SubscribeOptions(
                null,
                null,
                EventPosition(AutomaticDemoState.offset, null, null, null),
                null,
                null,
                null))
        .then((subscription) {
      AutomaticDemoState.subscription = subscription;
    });
  }

  void _refreshVerticalBarchart() {
    AutomaticDemoState.vBarChartModelList.clear();
    if (AutomaticDemoState.stopRequest == false) {
      var orderSourceIdList = List<String>.empty(growable: true);
      for (var order in AutomaticDemoState.orderList) {
        var orderSourceId =
            orderSourceIdList.firstOrNullWhere((x) => x == order.sourceId);
        if (orderSourceId == null) {
          orderSourceIdList.add(order.sourceId);
        }
      }
      for (var orderSourceId in orderSourceIdList) {
        var countOrderSourceId = AutomaticDemoState.orderList
            .where((x) => x.sourceId == orderSourceId)
            .toList()
            .length as double;
        var stringOrderSourceId = countOrderSourceId.toString();
        if (countOrderSourceId > AutomaticDemoState.maxMessagesSecond) {
          AutomaticDemoState.maxMessagesSecond = countOrderSourceId;
        }
        AutomaticDemoState.vBarChartModelList.add(VBarChartModel(
          index: AutomaticDemoState.vBarChartModelList.length,
          label: orderSourceId,
          colors: [Colors.orange, Colors.deepOrange],
          jumlah: countOrderSourceId,
          tooltip: stringOrderSourceId,
        ));
      }
      AutomaticDemoState.orderList.clear();
      Future.delayed(Duration(seconds: 1)).then((_) {
        _refreshVerticalBarchart();
      });
    } else {
      Configuration.eventHubConsumerClientApplicationService!
          .closeSubscription(AutomaticDemoState.subscription!)
          .then((value) {
        AutomaticDemoState.incomingEventStreamController!.close().then((value) {
          Configuration.eventHubConsumerClientApplicationService!
              .closeEventHubConsumerClient(
                  AutomaticDemoState.eventHubConsumerClient!)
              .then((value) {
            AutomaticDemoState.incomingEventStreamController = null;
            AutomaticDemoState.subscription = null;
            AutomaticDemoState.eventHubConsumerClient = null;
            AutomaticDemoState.maxMessagesSecond = 0;
          });
        });
      });
    }
  }
}
