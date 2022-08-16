import 'dart:async';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptResultStreamSink.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';

abstract class IJavascriptApplicationService {
  Future<void> initialize();
  Future<void> subscribeJavascriptResultStreamSink(
      JavascriptResultStreamSink javascriptResultStreamSink);
  Future<void> unsubscribeJavascriptResultStreamSink(
      JavascriptResultStreamSink javascriptResultStreamSink);
  Future<void> executeJavascriptCode(
      JavascriptTransaction javascriptTransaction);
  Future<void> finalize();
}
