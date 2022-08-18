import 'package:flutter_azure_event_hubs/Domain/Entities/PartitionContext.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/ReceivedEventData.dart';

class IncomingEvent {
  final Iterable<ReceivedEventData> receivedEventDataList;
  final PartitionContext partitionContext;
  IncomingEvent(this.receivedEventDataList, this.partitionContext);
}
