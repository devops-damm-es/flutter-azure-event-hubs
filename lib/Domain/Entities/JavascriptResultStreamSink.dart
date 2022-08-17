import 'dart:async';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptResult.dart';

class JavascriptResultStreamSink {
  final String id;
  final StreamSink<JavascriptResult> javascriptResultStreamSink;
  JavascriptResultStreamSink(this.id, this.javascriptResultStreamSink);
}
