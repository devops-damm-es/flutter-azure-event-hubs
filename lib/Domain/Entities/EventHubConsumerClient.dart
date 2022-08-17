class EventHubConsumerClient {
  final String id;
  final String consumerGroup;
  final String connectionString;
  final String eventHubName;
  EventHubConsumerClient(
      this.id, this.consumerGroup, this.connectionString, this.eventHubName);
}
