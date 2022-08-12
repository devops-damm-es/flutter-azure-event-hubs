import 'package:flutter_azure_event_hubs/Domain/Entities/EventData.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventHubProducerClient.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SendBatchOptions.dart';

abstract class IEventHubProducerClientRepositoryService {
  Future<JavascriptTransaction>
      getCreateEventHubProducerClientJavascriptTransaction(
          EventHubProducerClient eventHubProducerClient);
  Future<JavascriptTransaction> getSendEventDataBatchJavascriptTransaction(
      EventHubProducerClient eventHubProducerClient,
      Iterable<EventData> eventDataList,
      SendBatchOptions? sendBatchOptions);
}
