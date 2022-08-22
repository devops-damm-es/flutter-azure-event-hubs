import 'dart:async';

import 'package:flutter_azure_event_hubs/Application/IEventHubConsumerClientApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/IJavascriptApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/IIncomingEventMapperService.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventHubConsumerClient.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/IncomingEvent.dart';
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
  final IIncomingEventMapperService _incomingEventMapperService;

  EventHubConsumerClientApplicationService(
      this._eventHubConsumerClientDomainService,
      this._javascriptApplicationService,
      this._incomingEventMapperService);

  JavascriptResultStreamSink? _javascriptResultIncomingEventStreamSink;
  StreamController<JavascriptResult>?
      // ignore: close_sinks
      _javascriptResultIncomingEventStreamController;

  final List<Subscription> _subscriptionList =
      List<Subscription>.empty(growable: true);

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
    await _javascriptApplicationService
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
    await waitStreamController.close();

    await _javascriptApplicationService
        .unsubscribeJavascriptResultStreamSink(javascriptResultStreamSink);
    await javascriptResultStreamController.close();

    if (javascriptResult!.success == true) {
      return Future.value(eventHubConsumerClient);
    } else {
      throw new Exception(javascriptResult!.result);
    }
  }

  @override
  Future<Subscription> subscribe(EventHubConsumerClient eventHubConsumerClient,
      StreamSink<IncomingEvent> incomingEventStreamSink,
      {SubscribeOptions? subscribeOptions}) async {
    if (_javascriptResultIncomingEventStreamController == null &&
        _javascriptResultIncomingEventStreamSink == null) {
      _javascriptResultIncomingEventStreamController =
          StreamController<JavascriptResult>();
      _javascriptResultIncomingEventStreamController!.stream.listen((event) {
        for (var subscription in _subscriptionList) {
          if (event.javascriptTransactionId == subscription.id) {
            _incomingEventMapperService.fromJson(event.result).then((value) {
              subscription.incomingEventStreamSink.add(value);
            });
          }
        }
      });

      _javascriptResultIncomingEventStreamSink = JavascriptResultStreamSink(
          Uuid().v4(), _javascriptResultIncomingEventStreamController!.sink);
      await _javascriptApplicationService.subscribeJavascriptResultStreamSink(
          _javascriptResultIncomingEventStreamSink!);
    }

    var subscription = Subscription(
        Uuid().v4(), eventHubConsumerClient.id, incomingEventStreamSink);

    var waitStreamController = StreamController<bool>();
    var javascriptResultStreamController = StreamController<JavascriptResult>();
    var javascriptResultStreamSink = JavascriptResultStreamSink(
        Uuid().v4(), javascriptResultStreamController.sink);
    await _javascriptApplicationService
        .subscribeJavascriptResultStreamSink(javascriptResultStreamSink);

    var subscribeJavascriptTransaction =
        await _eventHubConsumerClientDomainService.repositoryService
            .getSubscribeJavascriptTransaction(
                eventHubConsumerClient, subscription, subscribeOptions);

    JavascriptResult? javascriptResult;
    javascriptResultStreamController.stream.listen((event) {
      if (event.javascriptTransactionId == subscribeJavascriptTransaction.id) {
        javascriptResult = event;
        waitStreamController.sink.add(true);
      }
    });
    await _javascriptApplicationService
        .executeJavascriptCode(subscribeJavascriptTransaction);
    await waitStreamController.stream.first;
    await waitStreamController.close();

    await _javascriptApplicationService
        .unsubscribeJavascriptResultStreamSink(javascriptResultStreamSink);
    await javascriptResultStreamController.close();

    if (javascriptResult!.success == true) {
      _subscriptionList.add(subscription);
      return Future.value(subscription);
    } else {
      throw new Exception(javascriptResult!.result);
    }
  }

  @override
  Future<void> closeSubscription(Subscription subscription) async {
    var waitStreamController = StreamController<bool>();
    var javascriptResultStreamController = StreamController<JavascriptResult>();
    var javascriptResultStreamSink = JavascriptResultStreamSink(
        Uuid().v4(), javascriptResultStreamController.sink);
    await _javascriptApplicationService
        .subscribeJavascriptResultStreamSink(javascriptResultStreamSink);

    var closeSubscriptionJavascriptTransaction =
        await _eventHubConsumerClientDomainService.repositoryService
            .getCloseSubscriptionJavascriptTransaction(subscription);

    JavascriptResult? javascriptResult;
    javascriptResultStreamController.stream.listen((event) {
      if (event.javascriptTransactionId ==
          closeSubscriptionJavascriptTransaction.id) {
        javascriptResult = event;
        waitStreamController.sink.add(true);
      }
    });
    await _javascriptApplicationService
        .executeJavascriptCode(closeSubscriptionJavascriptTransaction);
    await waitStreamController.stream.first;
    await waitStreamController.close();

    await _javascriptApplicationService
        .unsubscribeJavascriptResultStreamSink(javascriptResultStreamSink);
    await javascriptResultStreamController.close();

    if (javascriptResult!.success == true) {
      _subscriptionList.removeWhere((element) => element.id == subscription.id);
      if (_subscriptionList.isEmpty) {
        await _javascriptApplicationService
            .unsubscribeJavascriptResultStreamSink(
                _javascriptResultIncomingEventStreamSink!);
        await _javascriptResultIncomingEventStreamController!.close();
        _javascriptResultIncomingEventStreamController = null;
        _javascriptResultIncomingEventStreamSink = null;
      }
    } else {
      throw new Exception(javascriptResult!.result);
    }
  }
}
