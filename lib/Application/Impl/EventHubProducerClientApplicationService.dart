import 'dart:async';

import 'package:flutter_azure_event_hubs/Application/IEventHubProducerClientApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/IJavascriptApplicationService.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventData.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventHubProducerClient.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptResult.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptResultStreamSink.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SendBatchOptions.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/IEventHubProducerClientDomainService.dart';
import 'package:uuid/uuid.dart';

class EventHubProducerClientApplicationService
    extends IEventHubProducerClientApplicationService {
  final IEventHubProducerClientDomainService
      _eventHubProducerClientDomainService;
  final IJavascriptApplicationService _javascriptApplicationService;

  EventHubProducerClientApplicationService(
      this._eventHubProducerClientDomainService,
      this._javascriptApplicationService);

  @override
  Future<EventHubProducerClient> createEventHubProducerClient(
      String connectionString, String eventHubName) async {
    var eventHubProducerClient =
        EventHubProducerClient(Uuid().v4(), connectionString, eventHubName);

    var javascriptResultStreamController = StreamController<JavascriptResult>();
    var javascriptResultStreamSink = JavascriptResultStreamSink(
        Uuid().v4(), javascriptResultStreamController.sink);
    _javascriptApplicationService
        .subscribeJavascriptResultStreamSink(javascriptResultStreamSink);

    var createEventHubProducerClientJavascriptTransaction =
        await _eventHubProducerClientDomainService.repositoryService
            .getCreateEventHubProducerClientJavascriptTransaction(
                eventHubProducerClient);

    var waitForResult = true;
    JavascriptResult? javascriptResult;
    javascriptResultStreamController.stream.listen((event) {
      if (event.javascriptTransactionId ==
          createEventHubProducerClientJavascriptTransaction.id) {
        javascriptResult = event;
        waitForResult = false;
      }
    });
    _javascriptApplicationService.executeJavascriptCode(
        createEventHubProducerClientJavascriptTransaction);
    while (waitForResult) {
      await Future.delayed(Duration(milliseconds: 100));
    }

    _javascriptApplicationService
        .unsubscribeJavascriptResultStreamSink(javascriptResultStreamSink);
    javascriptResultStreamController.close();

    if (javascriptResult!.success == true) {
      return Future.value(eventHubProducerClient);
    } else {
      throw new Exception(javascriptResult!.result);
    }
  }

  @override
  Future<void> sendEventDataBatch(EventHubProducerClient eventHubProducerClient,
      Iterable<EventData> eventDataList,
      {SendBatchOptions? sendBatchOptions}) async {
    var javascriptResultStreamController = StreamController<JavascriptResult>();
    var javascriptResultStreamSink = JavascriptResultStreamSink(
        Uuid().v4(), javascriptResultStreamController.sink);
    _javascriptApplicationService
        .subscribeJavascriptResultStreamSink(javascriptResultStreamSink);

    var sendBatchJavascriptTransaction =
        await _eventHubProducerClientDomainService.repositoryService
            .getSendEventDataBatchJavascriptTransaction(
                eventHubProducerClient, eventDataList, sendBatchOptions);

    var waitForResult = true;
    JavascriptResult? javascriptResult;
    javascriptResultStreamController.stream.listen((event) {
      if (event.javascriptTransactionId == sendBatchJavascriptTransaction.id) {
        javascriptResult = event;
        waitForResult = false;
      }
    });
    _javascriptApplicationService
        .executeJavascriptCode(sendBatchJavascriptTransaction);
    while (waitForResult) {
      await Future.delayed(Duration(milliseconds: 100));
    }

    _javascriptApplicationService
        .unsubscribeJavascriptResultStreamSink(javascriptResultStreamSink);
    javascriptResultStreamController.close();

    if (javascriptResult!.success == false) {
      throw new Exception(javascriptResult!.result);
    }
  }
}
