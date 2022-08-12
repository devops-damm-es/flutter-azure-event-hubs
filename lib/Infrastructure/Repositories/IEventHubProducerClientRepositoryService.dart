import 'package:flutter_azure_event_hubs/Domain/Entities/EventData.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventHubProducerClient.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';

abstract class IEventHubProducerClientRepositoryService {
  Future<JavascriptTransaction>
      getCreateEventHubProducerClientJavascriptTransaction(
          EventHubProducerClient eventHubProducerClient);
  Future<JavascriptTransaction> getSendBatchJavascriptTransaction(
      EventHubProducerClient eventHubProducerClient,
      Iterable<EventData> eventDataList);
}
