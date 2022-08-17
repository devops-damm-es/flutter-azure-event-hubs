import 'package:flutter_azure_event_hubs/Domain/Entities/EventPosition.dart';

class SubscribeOptions {
  final int? maxBatchSize;
  final int? maxWaitTimeInSeconds;
  final EventPosition? startPosition;
  final bool? trackLastEnqueuedEventProperties;
  final int? ownerLevel;
  final bool? skipParsingBodyAsJson;
  SubscribeOptions(
      this.maxBatchSize,
      this.maxWaitTimeInSeconds,
      this.startPosition,
      this.trackLastEnqueuedEventProperties,
      this.ownerLevel,
      this.skipParsingBodyAsJson);
}
