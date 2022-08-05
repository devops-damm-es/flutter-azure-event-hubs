import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptResult.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IJavascriptRepositoryService.dart';
import 'package:interactive_webview_null_safety/interactive_webview.dart';

class JavascriptRepositoryService extends IJavascriptRepositoryService {
  final interactiveWebView = InteractiveWebView();

  Future<void> initialize() async {
    await interactiveWebView.loadHTML("<html><head></head><body></body></html>",
        baseUrl: "http://127.0.0.1");

    bool didFinish = false;
    interactiveWebView.stateChanged.listen((state) async {
      if (state.type == WebViewState.didFinish) {
        await interactiveWebView.evalJavascript(
            "const javascriptResult = typeof webkit !== 'undefined' ? webkit.messageHandlers.native : window.native;");
        didFinish = true;
      }
    });

    while (didFinish == false) {
      await Future.delayed(Duration(milliseconds: 200));
    }

    interactiveWebView.didReceiveMessage.listen((event) {
      print("event.name: " + event.name + ", event.data: " + event.data);
    });
  }

  Future<void> executeJavascriptCode(
      JavascriptTransaction javascriptTransaction,
      Stream<JavascriptResult> javascriptResultStream) async {
    await interactiveWebView
        .evalJavascript(javascriptTransaction.javascriptCode);
  }
}
