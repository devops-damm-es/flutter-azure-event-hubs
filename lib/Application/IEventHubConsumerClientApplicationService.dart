import 'package:flutter_azure_event_hubs/Domain/Entities/EventHubConsumerClient.dart';

abstract class IEventHubConsumerClientApplicationService {
  Future<EventHubConsumerClient> createEventHubConsumerClient(
      String consumerGroup, String connectionString, String eventHubName);
}
