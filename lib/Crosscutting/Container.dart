import 'package:flutter_azure_event_hubs/Application/IJavascriptApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/Impl/JavascriptApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/IJavascriptResultMapperService.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/IJavascriptTransactionMapperService.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/Impl/JavascriptResultMapperService.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/Impl/JavascriptTransactionMapperService.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/IJavascriptDomainService.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/Impl/JavascriptDomainService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IJavascriptRepositoryService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/Impl/JavascriptRepositoryService.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class Container {
  static void registerInKiwiContainer(kiwi.KiwiContainer container) {
    // Application Services
    container.registerFactory<IJavascriptResultMapperService>((c) =>
        new JavascriptResultMapperService(
            c.resolve<IJavascriptTransactionMapperService>()));
    container.registerFactory<IJavascriptTransactionMapperService>(
        (c) => new JavascriptTransactionMapperService());

    container.registerSingleton<IJavascriptApplicationService>((c) =>
        new JavascriptApplicationService(c.resolve<IJavascriptDomainService>(),
            c.resolve<IJavascriptResultMapperService>()));

    // Domain Services
    container.registerSingleton<IJavascriptDomainService>((c) =>
        new JavascriptDomainService(c.resolve<IJavascriptRepositoryService>()));

    // Repository Services
    container.registerSingleton<IJavascriptRepositoryService>(
        (c) => new JavascriptRepositoryService());
  }
}
