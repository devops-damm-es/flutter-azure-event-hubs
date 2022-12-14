import 'dart:async';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';

abstract class IJavascriptRepositoryService {
  Future<void> initialize(StreamSink<String> javascriptMessageStringStreamSink);
  Future<void> executeJavascriptCode(
      JavascriptTransaction javascriptTransaction);
}
