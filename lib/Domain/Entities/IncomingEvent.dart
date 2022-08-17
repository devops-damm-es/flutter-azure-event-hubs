import 'package:flutter_azure_event_hubs/Domain/Entities/PartitionContext.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/ReceivedEventData.dart';

class IncomingEvent {
  final ReceivedEventData receivedEventData;
  final PartitionContext partitionContext;
  IncomingEvent(this.receivedEventData, this.partitionContext);
}
