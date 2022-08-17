import 'dart:async';

import 'package:flutter_azure_event_hubs/Application/IEventHubConsumerClientApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/IJavascriptApplicationService.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventHubConsumerClient.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptResult.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptResultStreamSink.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SubscribeOptions.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/Subscription.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/IEventHubConsumerClientDomainService.dart';
import 'package:uuid/uuid.dart';

class EventHubConsumerClientApplicationService
    extends IEventHubConsumerClientApplicationService {
  final IEventHubConsumerClientDomainService
      _eventHubConsumerClientDomainService;
  final IJavascriptApplicationService _javascriptApplicationService;

  EventHubConsumerClientApplicationService(
      this._eventHubConsumerClientDomainService,
      this._javascriptApplicationService);

  @override
  Future<EventHubConsumerClient> createEventHubConsumerClient(
      String consumerGroup,
      String connectionString,
      String eventHubName) async {
    var eventHubConsumerClient = EventHubConsumerClient(
        Uuid().v4(), consumerGroup, connectionString, eventHubName);

    var waitStreamController = StreamController<bool>();
    var javascriptResultStreamController = StreamController<JavascriptResult>();
    var javascriptResultStreamSink = JavascriptResultStreamSink(
        Uuid().v4(), javascriptResultStreamController.sink);
    _javascriptApplicationService
        .subscribeJavascriptResultStreamSink(javascriptResultStreamSink);

    var createEventHubConsumerClientJavascriptTransaction =
        await _eventHubConsumerClientDomainService.repositoryService
            .getCreateEventHubConsumerClientJavascriptTransaction(
                eventHubConsumerClient);

    JavascriptResult? javascriptResult;
    javascriptResultStreamController.stream.listen((event) {
      if (event.javascriptTransactionId ==
          createEventHubConsumerClientJavascriptTransaction.id) {
        javascriptResult = event;
        waitStreamController.sink.add(true);
      }
    });
    _javascriptApplicationService.executeJavascriptCode(
        createEventHubConsumerClientJavascriptTransaction);
    await waitStreamController.stream.first;
    waitStreamController.close();

    _javascriptApplicationService
        .unsubscribeJavascriptResultStreamSink(javascriptResultStreamSink);
    javascriptResultStreamController.close();

    if (javascriptResult!.success == true) {
      return Future.value(eventHubConsumerClient);
    } else {
      throw new Exception(javascriptResult!.result);
    }
  }

  @override
  Future<Subscription> subscribe(EventHubConsumerClient eventHubConsumerClient,
      {SubscribeOptions? subscribeOptions}) async {
    var waitStreamController = StreamController<bool>();
    var javascriptResultStreamController = StreamController<JavascriptResult>();
    var javascriptResultStreamSink = JavascriptResultStreamSink(
        Uuid().v4(), javascriptResultStreamController.sink);
    _javascriptApplicationService
        .subscribeJavascriptResultStreamSink(javascriptResultStreamSink);

    var subscribeJavascriptTransaction =
        await _eventHubConsumerClientDomainService.repositoryService
            .getSubscribeJavascriptTransaction(
                eventHubConsumerClient, subscribeOptions);

    JavascriptResult? javascriptResult;
    javascriptResultStreamController.stream.listen((event) {
      if (event.javascriptTransactionId == subscribeJavascriptTransaction.id) {
        javascriptResult = event;
        waitStreamController.sink.add(true);
      }
    });
    _javascriptApplicationService
        .executeJavascriptCode(subscribeJavascriptTransaction);
    await waitStreamController.stream.first;
    waitStreamController.close();

    _javascriptApplicationService
        .unsubscribeJavascriptResultStreamSink(javascriptResultStreamSink);
    javascriptResultStreamController.close();

    if (javascriptResult!.success == true) {
      return Future.value(Subscription(Uuid().v4()));
    } else {
      throw new Exception(javascriptResult!.result);
    }
  }
}
