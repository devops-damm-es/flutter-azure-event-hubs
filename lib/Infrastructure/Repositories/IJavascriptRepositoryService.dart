import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';

abstract class IJavascriptRepositoryService {
  Future<void> initialize();
  Future<void> executeJavascriptCode(
      JavascriptTransaction javascriptTransaction);
}
