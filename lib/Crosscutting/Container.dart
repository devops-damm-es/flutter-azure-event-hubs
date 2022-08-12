import 'package:flutter_azure_event_hubs/Application/IJavascriptApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/IJavascriptClientLibraryApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/Impl/JavascriptApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/Impl/JavascriptClientLibraryApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/IJavascriptResultMapperService.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/IJavascriptTransactionMapperService.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/Impl/JavascriptResultMapperService.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/Impl/JavascriptTransactionMapperService.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/IJavascriptClientLibraryDomainService.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/IJavascriptDomainService.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/Impl/JavascriptClientLibraryDomainService.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/Impl/JavascriptDomainService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IJavascriptClientLibraryRepositoryService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IJavascriptRepositoryService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/Impl/JavascriptClientLibraryRepositoryService.dart';
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
    container.registerFactory<IJavascriptClientLibraryApplicationService>((c) =>
        new JavascriptClientLibraryApplicationService(
            c.resolve<IJavascriptClientLibraryDomainService>(),
            c.resolve<IJavascriptApplicationService>()));

    // Domain Services
    container.registerSingleton<IJavascriptClientLibraryDomainService>((c) =>
        new JavascriptClientLibraryDomainService(
            c.resolve<IJavascriptClientLibraryRepositoryService>()));
    container.registerSingleton<IJavascriptDomainService>((c) =>
        new JavascriptDomainService(c.resolve<IJavascriptRepositoryService>()));

    // Repository Services
    container.registerFactory<IJavascriptClientLibraryRepositoryService>(
        (c) => new JavascriptClientLibraryRepositoryService());
    container.registerSingleton<IJavascriptRepositoryService>(
        (c) => new JavascriptRepositoryService());
  }
}
