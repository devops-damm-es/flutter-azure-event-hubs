import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IJavascriptRepositoryService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/Impl/JavascriptRepositoryService.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class Container {
  static void registerInKiwiContainer(kiwi.KiwiContainer container) {
    // Application Services

    // Domain Services

    // Repository Services
    container.registerSingleton<IJavascriptRepositoryService>(
        (c) => new JavascriptRepositoryService());
  }
}
