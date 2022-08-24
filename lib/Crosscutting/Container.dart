import 'package:flutter_azure_event_hubs/Application/IClientSecretCredentialApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/IEventHubConsumerClientApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/IEventHubProducerClientApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/IJavascriptApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/IJavascriptClientLibraryApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/ISchemaRegistryClientApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/Impl/ClientSecretCredentialApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/Impl/EventHubConsumerClientApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/Impl/EventHubProducerClientApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/Impl/JavascriptApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/Impl/JavascriptClientLibraryApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/Impl/SchemaRegistryClientApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/IDateTimeMapperService.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/IIncomingEventMapperService.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/IJavascriptResultMapperService.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/IJavascriptTransactionMapperService.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/IPartitionContextMapperService.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/IReceivedEventDataMapperService.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/Impl/DateTimeMapperService.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/Impl/IncomingEventMapperService.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/Impl/JavascriptResultMapperService.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/Impl/JavascriptTransactionMapperService.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/Impl/PartitionContextMapperService.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/Impl/ReceivedEventDataMapperService.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/IClientSecretCredentialDomainService.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/IEventHubConsumerClientDomainService.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/IEventHubProducerClientDomainService.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/IJavascriptClientLibraryDomainService.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/IJavascriptDomainService.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/ISchemaRegistryClientDomainService.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/Impl/ClientSecretCredentialDomainService.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/Impl/EventHubConsumerClientDomainService.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/Impl/EventHubProducerClientDomainService.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/Impl/JavascriptClientLibraryDomainService.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/Impl/JavascriptDomainService.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/Impl/SchemaRegistryClientDomainService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/IEventDataMapperService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/IEventPositionMapperService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/ISchemaRegistryClientOptionsMapperService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/ISendBatchOptionsMapperService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/ISubscribeOptionsMapperService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/ITokenCredentialOptionsMapperService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/Impl/EventDataMapperService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/Impl/EventPositionMapperService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/Impl/SchemaRegistryClientOptionsMapperService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/Impl/SendBatchOptionsMapperService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/Impl/SubscribeOptionsMapperService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/Impl/TokenCredentialOptionsMapperService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IClientSecretCredentialRepositoryService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IEventHubConsumerClientRepositoryService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IEventHubProducerClientRepositoryService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IJavascriptClientLibraryRepositoryService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IJavascriptRepositoryService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/ISchemaRegistryClientRepositoryService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/Impl/ClientSecretCredentialRepositoryService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/Impl/EventHubConsumerClientRepositoryService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/Impl/EventHubProducerClientRepositoryService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/Impl/JavascriptClientLibraryRepositoryService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/Impl/JavascriptRepositoryService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/Impl/SchemaRegistryClientRepositoryService.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class Container {
  static void registerInKiwiContainer(kiwi.KiwiContainer container) {
    // Application Services
    container.registerFactory<IDateTimeMapperService>(
        (c) => new DateTimeMapperService());
    container.registerFactory<IIncomingEventMapperService>((c) =>
        new IncomingEventMapperService(
            c.resolve<IReceivedEventDataMapperService>(),
            c.resolve<IPartitionContextMapperService>()));
    container.registerFactory<IJavascriptResultMapperService>(
        (c) => new JavascriptResultMapperService());
    container.registerFactory<IJavascriptTransactionMapperService>(
        (c) => new JavascriptTransactionMapperService());
    container.registerFactory<IPartitionContextMapperService>(
        (c) => new PartitionContextMapperService());
    container.registerFactory<IReceivedEventDataMapperService>((c) =>
        new ReceivedEventDataMapperService(
            c.resolve<IDateTimeMapperService>()));

    container.registerFactory<IClientSecretCredentialApplicationService>((c) =>
        new ClientSecretCredentialApplicationService(
            c.resolve<IClientSecretCredentialDomainService>(),
            c.resolve<IJavascriptApplicationService>()));
    container.registerFactory<IEventHubConsumerClientApplicationService>((c) =>
        new EventHubConsumerClientApplicationService(
            c.resolve<IEventHubConsumerClientDomainService>(),
            c.resolve<IJavascriptApplicationService>(),
            c.resolve<IIncomingEventMapperService>()));
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
    container.registerFactory<ISchemaRegistryClientApplicationService>((c) =>
        new SchemaRegistryClientApplicationService(
            c.resolve<ISchemaRegistryClientDomainService>(),
            c.resolve<IJavascriptApplicationService>()));

    // Domain Services
    container.registerFactory<IClientSecretCredentialDomainService>((c) =>
        new ClientSecretCredentialDomainService(
            c.resolve<IClientSecretCredentialRepositoryService>()));
    container.registerFactory<IEventHubConsumerClientDomainService>((c) =>
        new EventHubConsumerClientDomainService(
            c.resolve<IEventHubConsumerClientRepositoryService>()));
    container.registerFactory<IEventHubProducerClientDomainService>((c) =>
        new EventHubProducerClientDomainService(
            c.resolve<IEventHubProducerClientRepositoryService>()));
    container.registerFactory<IJavascriptClientLibraryDomainService>((c) =>
        new JavascriptClientLibraryDomainService(
            c.resolve<IJavascriptClientLibraryRepositoryService>()));
    container.registerSingleton<IJavascriptDomainService>((c) =>
        new JavascriptDomainService(c.resolve<IJavascriptRepositoryService>()));
    container.registerFactory<ISchemaRegistryClientDomainService>((c) =>
        new SchemaRegistryClientDomainService(
            c.resolve<ISchemaRegistryClientRepositoryService>()));

    // Repository Services
    container.registerFactory<IEventDataMapperService>(
        (c) => new EventDataMapperService());
    container.registerFactory<IEventPositionMapperService>(
        (c) => new EventPositionMapperService());
    container.registerFactory<ISchemaRegistryClientOptionsMapperService>(
        (c) => new SchemaRegistryClientOptionsMapperService());
    container.registerFactory<ISendBatchOptionsMapperService>(
        (c) => new SendBatchOptionsMapperService());
    container.registerFactory<ISubscribeOptionsMapperService>((c) =>
        new SubscribeOptionsMapperService(
            c.resolve<IEventPositionMapperService>()));
    container.registerFactory<ITokenCredentialOptionsMapperService>(
        (c) => new TokenCredentialOptionsMapperService());

    container.registerFactory<IClientSecretCredentialRepositoryService>((c) =>
        new ClientSecretCredentialRepositoryService(
            c.resolve<ITokenCredentialOptionsMapperService>()));
    container.registerFactory<IEventHubConsumerClientRepositoryService>((c) =>
        new EventHubConsumerClientRepositoryService(
            c.resolve<ISubscribeOptionsMapperService>()));
    container.registerFactory<IEventHubProducerClientRepositoryService>((c) =>
        new EventHubProducerClientRepositoryService(
            c.resolve<IEventDataMapperService>(),
            c.resolve<ISendBatchOptionsMapperService>()));
    container.registerFactory<IJavascriptClientLibraryRepositoryService>(
        (c) => new JavascriptClientLibraryRepositoryService());
    container.registerSingleton<IJavascriptRepositoryService>(
        (c) => new JavascriptRepositoryService());
    container.registerFactory<ISchemaRegistryClientRepositoryService>((c) =>
        new SchemaRegistryClientRepositoryService(
            c.resolve<ISchemaRegistryClientOptionsMapperService>()));
  }
}
