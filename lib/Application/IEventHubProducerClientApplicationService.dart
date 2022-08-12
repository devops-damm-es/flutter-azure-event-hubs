import 'package:flutter_azure_event_hubs/Domain/Entities/EventData.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventHubProducerClient.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SendBatchOptions.dart';

abstract class IEventHubProducerClientApplicationService {
  Future<EventHubProducerClient> createEventHubProducerClient(
      String connectionString, String eventHubName);
  Future<void> sendEventDataBatch(EventHubProducerClient eventHubProducerClient,
      Iterable<EventData> eventDataList,
      {SendBatchOptions? sendBatchOptions});
}
