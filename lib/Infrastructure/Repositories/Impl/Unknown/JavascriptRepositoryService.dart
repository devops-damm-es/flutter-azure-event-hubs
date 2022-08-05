import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptResult.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IJavascriptRepositoryService.dart';

class JavascriptRepositoryService extends IJavascriptRepositoryService {
  Future<void> initialize() async {}

  Future<void> executeJavascriptCode(
      JavascriptTransaction javascriptTransaction,
      Stream<JavascriptResult> javascriptResultStream) async {}
}
