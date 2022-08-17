class PartitionContext {
  final String fullyQualifiedNamespace;
  final String eventHubName;
  final String consumerGroup;
  final String partitionId;
  PartitionContext(this.fullyQualifiedNamespace, this.eventHubName,
      this.consumerGroup, this.partitionId);
}
