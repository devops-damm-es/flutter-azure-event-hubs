import 'dart:async';

import 'package:flutter_azure_event_hubs/Domain/Entities/IncomingEvent.dart';

class Subscription {
  final String id;
  //final StreamSink<IncomingEvent> incomingEventStreamSink;
  Subscription(
    this.id,
    /*this.incomingEventStreamSink*/
  );
}
