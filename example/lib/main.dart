import 'dart:async';
import 'package:breakpoint/breakpoint.dart';
import 'package:flutter_azure_event_hubs/Application/IEventHubConsumerClientApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/IEventHubProducerClientApplicationService.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventData.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventHubConsumerClient.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventHubProducerClient.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventPosition.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/IncomingEvent.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SubscribeOptions.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/Subscription.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_azure_event_hubs/Application/IJavascriptApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/IJavascriptClientLibraryApplicationService.dart';
// ignore: library_prefixes
import 'Crosscutting/container.dart' as IoC;

IEventHubProducerClientApplicationService?
    eventHubProducerClientApplicationService;
IEventHubConsumerClientApplicationService?
    eventHubConsumerClientApplicationService;
String consumerGroup = "\$default";
String connectionString = "connectionString";
String eventHubName = "eventHubName";
EventHubProducerClient? eventHubProducerClient;
EventHubConsumerClient? eventHubConsumerClient;
StreamController<IncomingEvent>? incomingEventStreamController;
Subscription? subscription;

Future<void> main() async {
  IoC.Container.setup();
  WidgetsFlutterBinding.ensureInitialized();
  var javascriptApplicationService =
      IoC.Container.resolve<IJavascriptApplicationService>();
  await javascriptApplicationService.initialize();

  var javascriptClientLibraryApplicationService =
      IoC.Container.resolve<IJavascriptClientLibraryApplicationService>();
  await javascriptClientLibraryApplicationService.initialize();

  eventHubProducerClientApplicationService =
      IoC.Container.resolve<IEventHubProducerClientApplicationService>();
  eventHubConsumerClientApplicationService =
      IoC.Container.resolve<IEventHubConsumerClientApplicationService>();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Flutter Azure Event Hubs'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _eventHubProducerController =
      TextEditingController();
  final TextEditingController _eventHubConsumerController =
      TextEditingController();
  final ScrollController _verticalScrollController =
      ScrollController(initialScrollOffset: 0);
  final ScrollController _horizontalScrollController =
      ScrollController(initialScrollOffset: 0);

  void _sendEventDataBatch() {
    setState(() {
      eventHubProducerClientApplicationService!
          .createEventHubProducerClient(connectionString, eventHubName)
          .then((value) {
        _eventHubProducerController.text = DateTime.now().toString() +
            ": EventHubProducerClient created.\n" +
            _eventHubProducerController.text;
        eventHubProducerClient = value;

        var eventDataList = List<EventData>.empty(growable: true);
        eventDataList.add(EventData(Uuid().v4()));
        eventDataList.add(EventData(1));
        eventDataList.add(EventData(DateTime.now().toUtc().toString()));

        eventHubProducerClientApplicationService!
            .sendEventDataBatch(eventHubProducerClient!, eventDataList)
            .then((value) {
          _eventHubProducerController.text = DateTime.now().toString() +
              ": Send new events.\n" +
              _eventHubProducerController.text;
          eventHubProducerClientApplicationService!
              .closeEventHubProducerClient(eventHubProducerClient!)
              .then((value) {
            _eventHubProducerController.text = DateTime.now().toString() +
                ": EventHubProducerClient closed.\n" +
                _eventHubProducerController.text;
          });
        });
      });
    });
  }

  void _createEventHubConsumerClient() {
    setState(() {
      if (eventHubConsumerClient == null) {
        eventHubConsumerClientApplicationService!
            .createEventHubConsumerClient(
                consumerGroup, connectionString, eventHubName)
            .then((value) {
          eventHubConsumerClient = value;
          _eventHubConsumerController.text = DateTime.now().toString() +
              ": EventHubConsumerClient created.\n" +
              _eventHubConsumerController.text;
        });
      } else {
        _eventHubConsumerController.text = DateTime.now().toString() +
            ": EventHubConsumerClient already created.\n" +
            _eventHubConsumerController.text;
      }
    });
  }

  void _subscribe() {
    setState(() {
      if (incomingEventStreamController == null) {
        incomingEventStreamController = StreamController<IncomingEvent>();
        incomingEventStreamController!.stream.listen((event) {
          setState(() {
            if (event.receivedEventDataList.isNotEmpty) {
              _eventHubConsumerController.text = DateTime.now().toString() +
                  ": Receive new event: " +
                  event.receivedEventDataList.first.body.toString() +
                  "\n" +
                  _eventHubConsumerController.text;
            }
          });
        });
        var subscribeOptions = SubscribeOptions(
            null, null, EventPosition(0, null, null, null), null, null, null);
        eventHubConsumerClientApplicationService!
            .subscribe(
                eventHubConsumerClient!, incomingEventStreamController!.sink,
                subscribeOptions: subscribeOptions)
            .then((value) {
          subscription = value;
          _eventHubConsumerController.text = DateTime.now().toString() +
              ": Subscribe.\n" +
              _eventHubConsumerController.text;
        });
      } else {
        _eventHubConsumerController.text = DateTime.now().toString() +
            ": Already subscribed.\n" +
            _eventHubConsumerController.text;
      }
    });
  }

  void _closeSubscription() {
    setState(() {
      eventHubConsumerClientApplicationService!
          .closeSubscription(subscription!)
          .then((value) {
        incomingEventStreamController!.close().then((value) {
          incomingEventStreamController = null;
          subscription = null;
          _eventHubConsumerController.text = DateTime.now().toString() +
              ": Subscription closed.\n" +
              _eventHubConsumerController.text;
        });
      });
    });
  }

  void _closeEventHubConsumerClient() {
    setState(() {
      eventHubConsumerClientApplicationService!
          .closeEventHubConsumerClient(eventHubConsumerClient!)
          .then((value) {
        if (incomingEventStreamController != null) {
          incomingEventStreamController!.close().then((value) {
            incomingEventStreamController = null;
            subscription = null;
            eventHubConsumerClient = null;
            _eventHubConsumerController.text = DateTime.now().toString() +
                ": EventHubConsumerClient closed.\n" +
                _eventHubConsumerController.text;
          });
        } else {
          eventHubConsumerClient = null;
          _eventHubConsumerController.text = DateTime.now().toString() +
              ": EventHubConsumerClient closed.\n" +
              _eventHubConsumerController.text;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(title: Text(widget.title));

    var width = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.left -
        MediaQuery.of(context).padding.right;
    if (width < 360) {
      width = 360;
    }

    var height = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    if (height < 360) {
      height = 360;
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

    return Scaffold(
        appBar: appBar,
        body: Scrollbar(
            thumbVisibility: true,
            trackVisibility: true,
            controller: _verticalScrollController,
            child: Scrollbar(
                thumbVisibility: true,
                trackVisibility: true,
                notificationPredicate: (notif) => notif.depth == 1,
                controller: _horizontalScrollController,
                child: SingleChildScrollView(
                    controller: _verticalScrollController,
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                        controller: _horizontalScrollController,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            width: breakpointMarginWidth,
                                            height: 10,
                                            color: Colors.pink),
                                        buttonsInBottom
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                    Container(
                                                        width: (breakpointColumnsWidth *
                                                                widthBreakpoint
                                                                    .columns) +
                                                            (breakpointGutterWidth *
                                                                (widthBreakpoint
                                                                        .columns -
                                                                    1)),
                                                        height: (breakpointColumnsHeight *
                                                                ((heightBreakpoint
                                                                            .columns /
                                                                        2) -
                                                                    1)) +
                                                            breakpointGutterHeight *
                                                                ((heightBreakpoint
                                                                            .columns /
                                                                        2) -
                                                                    2),
                                                        color: Colors.yellow),
                                                    Container(
                                                        width: 10,
                                                        height:
                                                            breakpointGutterHeight,
                                                        color: Colors.pink),
                                                    Container(
                                                        width: (breakpointColumnsWidth *
                                                                widthBreakpoint
                                                                    .columns) +
                                                            (breakpointGutterWidth *
                                                                (widthBreakpoint
                                                                        .columns -
                                                                    1)),
                                                        height:
                                                            breakpointColumnsHeight,
                                                        color: Colors.amber)
                                                  ])
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                    Container(
                                                        width: (breakpointColumnsWidth *
                                                                (widthBreakpoint
                                                                        .columns -
                                                                    2)) +
                                                            (breakpointGutterWidth *
                                                                (widthBreakpoint
                                                                        .columns -
                                                                    3)),
                                                        height: (breakpointColumnsHeight *
                                                                (heightBreakpoint
                                                                        .columns /
                                                                    2)) +
                                                            breakpointGutterHeight *
                                                                ((heightBreakpoint
                                                                            .columns /
                                                                        2) -
                                                                    1),
                                                        color: Colors.yellow),
                                                    Container(
                                                        width:
                                                            breakpointGutterWidth,
                                                        height: 10,
                                                        color: Colors.pink),
                                                    Container(
                                                        width: (breakpointColumnsWidth *
                                                                2) +
                                                            breakpointGutterWidth,
                                                        height: (breakpointColumnsHeight *
                                                                (heightBreakpoint
                                                                        .columns /
                                                                    2)) +
                                                            breakpointGutterHeight *
                                                                ((heightBreakpoint
                                                                            .columns /
                                                                        2) -
                                                                    1),
                                                        color: Colors.amber)
                                                  ]),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            width: breakpointMarginWidth,
                                            height: 10,
                                            color: Colors.pink),
                                        buttonsInBottom
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                    Container(
                                                        width: (breakpointColumnsWidth *
                                                                widthBreakpoint
                                                                    .columns) +
                                                            (breakpointGutterWidth *
                                                                (widthBreakpoint
                                                                        .columns -
                                                                    1)),
                                                        height: (breakpointColumnsHeight *
                                                                ((heightBreakpoint
                                                                            .columns /
                                                                        2) -
                                                                    1)) +
                                                            breakpointGutterHeight *
                                                                ((heightBreakpoint
                                                                            .columns /
                                                                        2) -
                                                                    2),
                                                        color: Colors.yellow),
                                                    Container(
                                                        width: 10,
                                                        height:
                                                            breakpointGutterHeight,
                                                        color: Colors.pink),
                                                    Container(
                                                        width: (breakpointColumnsWidth *
                                                                widthBreakpoint
                                                                    .columns) +
                                                            (breakpointGutterWidth *
                                                                (widthBreakpoint
                                                                        .columns -
                                                                    1)),
                                                        height:
                                                            breakpointColumnsHeight,
                                                        color: Colors.amber)
                                                  ])
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                    Container(
                                                        width: (breakpointColumnsWidth *
                                                                (widthBreakpoint
                                                                        .columns -
                                                                    2)) +
                                                            (breakpointGutterWidth *
                                                                (widthBreakpoint
                                                                        .columns -
                                                                    3)),
                                                        height: (breakpointColumnsHeight *
                                                                (heightBreakpoint
                                                                        .columns /
                                                                    2)) +
                                                            breakpointGutterHeight *
                                                                ((heightBreakpoint
                                                                            .columns /
                                                                        2) -
                                                                    1),
                                                        color: Colors.yellow),
                                                    Container(
                                                        width:
                                                            breakpointGutterWidth,
                                                        height: 10,
                                                        color: Colors.pink),
                                                    Container(
                                                        width: (breakpointColumnsWidth *
                                                                2) +
                                                            breakpointGutterWidth,
                                                        height: (breakpointColumnsHeight *
                                                                (heightBreakpoint
                                                                        .columns /
                                                                    2)) +
                                                            breakpointGutterHeight *
                                                                ((heightBreakpoint
                                                                            .columns /
                                                                        2) -
                                                                    1),
                                                        color: Colors.amber)
                                                  ]),
                                        Container(
                                            width: breakpointMarginWidth,
                                            height: 10,
                                            color: Colors.pink),
                                      ]),
                                  Container(
                                      width: 10,
                                      height: breakpointMarginHeight,
                                      color: Colors.pink),
                                ])))))),
        floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: _sendEventDataBatch,
                tooltip: 'Send Event Data',
                child: const Icon(Icons.send),
              ),
              Container(height: 10),
              FloatingActionButton(
                onPressed: _createEventHubConsumerClient,
                tooltip: 'Create Event Hub Consumer Client',
                child: const Icon(Icons.create),
              ),
              Container(height: 10),
              FloatingActionButton(
                onPressed: _subscribe,
                tooltip: 'Subscribe',
                child: const Icon(Icons.subscript),
              ),
              Container(height: 10),
              FloatingActionButton(
                onPressed: _closeSubscription,
                tooltip: 'Close Subscription',
                child: const Icon(Icons.close),
              ),
              Container(height: 10),
              FloatingActionButton(
                onPressed: _closeEventHubConsumerClient,
                tooltip: 'Close Event Hub Consumer Client',
                child: const Icon(Icons.remove),
              )
            ]));
  }
}
