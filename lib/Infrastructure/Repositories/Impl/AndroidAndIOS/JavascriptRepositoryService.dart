import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IJavascriptRepositoryService.dart';
import 'package:interactive_webview/interactive_webview.dart';

class JavascriptRepositoryService extends IJavascriptRepositoryService {
  final interactiveWebView = InteractiveWebView();

  Future<void> initialize(
      StreamSink<String> javascriptMessageStringStreamSink) async {
    await interactiveWebView.loadHTML("<html><head></head><body></body></html>",
        baseUrl: "http://localhost");

    var waitStreamController = StreamController<bool>();
    interactiveWebView.stateChanged.listen((state) async {
      if (state.type == WebViewState.didFinish) {
        await interactiveWebView.evalJavascript(
            "var proxyInterop = typeof webkit !== 'undefined' ? webkit.messageHandlers.native : window.native;");
        waitStreamController.sink.add(true);
      }
    });

    await waitStreamController.stream.first;
    waitStreamController.close();

    interactiveWebView.didReceiveMessage.listen((event) {
      compute(jsonEncode, event.data).then((value) {
        javascriptMessageStringStreamSink.add(value);
      }).onError((error, stackTrace) {
        try {
          javascriptMessageStringStreamSink.add(event.data);
        } catch (_) {
          print("Unknown javascript post message data type: " + event.data);
        }
      });
    });
  }

  Future<void> executeJavascriptCode(
      JavascriptTransaction javascriptTransaction) async {
    await interactiveWebView
        .evalJavascript(javascriptTransaction.javascriptCode);
  }
}
