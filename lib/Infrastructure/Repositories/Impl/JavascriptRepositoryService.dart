import 'dart:async';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IJavascriptRepositoryService.dart';
import './Web/JavascriptRepositoryService.dart'
    if (dart.library.io) './AndroidAndIOS/JavascriptRepositoryService.dart'
    as platform;

class JavascriptRepositoryService extends IJavascriptRepositoryService {
  final javascriptRepositoryService =
      new platform.JavascriptRepositoryService();

  Future<void> initialize(
      StreamSink<String> javascriptMessageStringStreamSink) async {
    return javascriptRepositoryService
        .initialize(javascriptMessageStringStreamSink);
  }

  Future<void> executeJavascriptCode(
      JavascriptTransaction javascriptTransaction) async {
    return javascriptRepositoryService
        .executeJavascriptCode(javascriptTransaction);
  }
}
