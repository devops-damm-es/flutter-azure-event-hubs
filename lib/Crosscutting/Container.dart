import 'package:flutter_azure_event_hubs/Application/IEventHubProducerClientApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/IJavascriptApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/IJavascriptClientLibraryApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/Impl/EventHubProducerClientApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/Impl/JavascriptApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/Impl/JavascriptClientLibraryApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/IJavascriptResultMapperService.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/IJavascriptTransactionMapperService.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/Impl/JavascriptResultMapperService.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/Impl/JavascriptTransactionMapperService.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/IEventHubProducerClientDomainService.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/IJavascriptClientLibraryDomainService.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/IJavascriptDomainService.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/Impl/EventHubProducerClientDomainService.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/Impl/JavascriptClientLibraryDomainService.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/Impl/JavascriptDomainService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/IEventDataMapperService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/ISendBatchOptionsMapperService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/Impl/EventDataMapperService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/Impl/SendBatchOptionsMapperService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IEventHubProducerClientRepositoryService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IJavascriptClientLibraryRepositoryService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IJavascriptRepositoryService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/Impl/EventHubProducerClientRepositoryService.dart';
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

    container.registerFactory<IEventHubProducerClientApplicationService>((c) =>
        new EventHubProducerClientApplicationService(
            c.resolve<IEventHubProducerClientDomainService>(),
            c.resolve<IJavascriptApplicationService>()));
    container.registerSingleton<IJavascriptApplicationService>((c) =>
        new JavascriptApplicationService(c.resolve<IJavascriptDomainService>(),
            c.resolve<IJavascriptResultMapperService>()));
    container.registerFactory<IJavascriptClientLibraryApplicationService>((c) =>
        new JavascriptClientLibraryApplicationService(
            c.resolve<IJavascriptClientLibraryDomainService>(),
            c.resolve<IJavascriptApplicationService>()));

    // Domain Services
    container.registerFactory<IEventHubProducerClientDomainService>((c) =>
        new EventHubProducerClientDomainService(
            c.resolve<IEventHubProducerClientRepositoryService>()));
    container.registerSingleton<IJavascriptClientLibraryDomainService>((c) =>
        new JavascriptClientLibraryDomainService(
            c.resolve<IJavascriptClientLibraryRepositoryService>()));
    container.registerSingleton<IJavascriptDomainService>((c) =>
        new JavascriptDomainService(c.resolve<IJavascriptRepositoryService>()));

    // Repository Services
    container.registerFactory<IEventDataMapperService>(
        (c) => new EventDataMapperService());
    container.registerFactory<ISendBatchOptionsMapperService>(
        (c) => new SendBatchOptionsMapperService());

    container.registerFactory<IEventHubProducerClientRepositoryService>((c) =>
        new EventHubProducerClientRepositoryService(
            c.resolve<IEventDataMapperService>(),
            c.resolve<ISendBatchOptionsMapperService>()));
    container.registerFactory<IJavascriptClientLibraryRepositoryService>(
        (c) => new JavascriptClientLibraryRepositoryService());
    container.registerSingleton<IJavascriptRepositoryService>(
        (c) => new JavascriptRepositoryService());
  }
}
