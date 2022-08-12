import 'package:flutter_azure_event_hubs/Domain/Entities/EventData.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/EventHubProducerClient.dart';

abstract class IEventHubProducerClientApplicationService {
  Future<EventHubProducerClient> createEventHubProducerClient(
      String connectionString, String eventHubName);
  Future<void> sendBatch(EventHubProducerClient eventHubProducerClient,
      Iterable<EventData> eventDataList);
}
