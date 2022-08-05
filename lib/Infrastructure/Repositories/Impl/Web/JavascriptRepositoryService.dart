import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptResult.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IJavascriptRepositoryService.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class JavascriptRepositoryService extends IJavascriptRepositoryService {
  Future<void> initialize() async {
    js.context.callMethod("eval", ["const javascriptResult = window.parent;"]);
    html.window.onMessage.listen((event) {
      print("event.type: " + event.type + ", event.data: " + event.data);
    });
  }

  Future<void> executeJavascriptCode(
      JavascriptTransaction javascriptTransaction,
      Stream<JavascriptResult> javascriptResultStream) async {
    js.context.callMethod("eval", [javascriptTransaction.javascriptCode]);
  }
}
