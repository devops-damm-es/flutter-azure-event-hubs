import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptResult.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IJavascriptRepositoryService.dart';
// ignore: unused_import
import './Unknown/JavascriptRepositoryService.dart' as platform
    if (dart.library.io) './AndroidAndIOS/JavascriptRepositoryService.dart'
    if (dart.library.html) './Web/JavascriptRepositoryService.dart';

class JavascriptRepositoryService extends IJavascriptRepositoryService {
  final javascriptRepositoryService = new platform.JavascriptRepositoryService();

  Future<void> initialize() async {
    return javascriptRepositoryService.initialize();
  }

  Future<void> executeJavascriptCode(
      JavascriptTransaction javascriptTransaction,
      Stream<JavascriptResult> javascriptResultStream) async {
    return javascriptRepositoryService.executeJavascriptCode(
        javascriptTransaction, javascriptResultStream);
  }
}
