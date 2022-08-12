import 'dart:async';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IJavascriptRepositoryService.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class JavascriptRepositoryService extends IJavascriptRepositoryService {
  Future<void> initialize(
      StreamSink<String> javascriptMessageStringStreamSink) async {
    js.context.callMethod("eval", ["var proxyInterop = window.parent;"]);
    html.window.onMessage.listen((event) {
      javascriptMessageStringStreamSink.add(event.data);
    });
  }

  Future<void> executeJavascriptCode(
      JavascriptTransaction javascriptTransaction) async {
    js.context.callMethod("eval", [javascriptTransaction.javascriptCode]);
  }
}
