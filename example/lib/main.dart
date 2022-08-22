import 'dart:async';
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
  try {
    eventHubConsumerClient = await eventHubConsumerClientApplicationService!
        .createEventHubConsumerClient(
            consumerGroup, connectionString, eventHubName);
  } catch (error) {
    var a = 1;
  }

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
  TextEditingController _eventHubProducerController = TextEditingController();
  TextEditingController _eventHubConsumerController = TextEditingController();

  void _sendEventDataBatch() {
    setState(() {
      eventHubProducerClientApplicationService!
          .createEventHubProducerClient(connectionString, eventHubName)
          .then((value) {
        _eventHubProducerController.text +=
            "Create new EventHubProducerClient.\n";
        eventHubProducerClient = value;

        var eventDataList = List<EventData>.empty(growable: true);
        eventDataList.add(EventData(Uuid().v4()));
        eventDataList.add(EventData(1));
        eventDataList.add(EventData(DateTime.now().toUtc().toString()));

        eventHubProducerClientApplicationService!
            .sendEventDataBatch(eventHubProducerClient!, eventDataList)
            .then((value) {
          _eventHubProducerController.text += "Send new events.\n";
          eventHubProducerClientApplicationService!
              .closeEventHubProducerClient(eventHubProducerClient!)
              .then((value) {
            _eventHubProducerController.text +=
                "Close EventHubProducerClient.\n";
          });
        });
      });
    });
  }

  void _subscribe() {
    setState(() {
      if (incomingEventStreamController == null) {
        incomingEventStreamController = StreamController<IncomingEvent>();
        incomingEventStreamController!.stream.listen((event) {
          setState(() {
            if (event.receivedEventDataList.isNotEmpty) {
              _eventHubConsumerController.text += "Receive new event: " +
                  event.receivedEventDataList.first.body.toString() +
                  "\n";
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
          _eventHubConsumerController.text += "Subscribe.\n";
        });
      } else {
        _eventHubConsumerController.text += "Already subscribed.\n";
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
          _eventHubConsumerController.text += "Subscription closed.\n";
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                  decoration: InputDecoration(labelText: 'Events sended:'),
                  controller: _eventHubProducerController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null),
              TextField(
                  decoration: InputDecoration(labelText: 'Events received:'),
                  controller: _eventHubConsumerController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null)
            ],
          ),
        ),
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
                onPressed: _subscribe,
                tooltip: 'Subscribe',
                child: const Icon(Icons.subscript),
              ),
              Container(height: 10),
              FloatingActionButton(
                onPressed: _closeSubscription,
                tooltip: 'Close',
                child: const Icon(Icons.close),
              )
            ]));
  }
}
