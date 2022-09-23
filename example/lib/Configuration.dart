import 'package:flutter_azure_event_hubs/Application/IAvroSerializerApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/IClientSecretCredentialApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/IEventHubConsumerClientApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/IEventHubProducerClientApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/ISchemaRegistryClientApplicationService.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/AvroSerializer.dart';

class Configuration {
  static IEventHubProducerClientApplicationService?
      eventHubProducerClientApplicationService;
  static IEventHubConsumerClientApplicationService?
      eventHubConsumerClientApplicationService;
  static IClientSecretCredentialApplicationService?
      clientSecretCredentialApplicationService;
  static ISchemaRegistryClientApplicationService?
      schemaRegistryClientApplicationService;
  static IAvroSerializerApplicationService? avroSerializerApplicationService;
  static String consumerGroup = "\$default";
  static String connectionString = "connectionString";
  static String tenantId = "tenantId";
  static String clientId = "clientId";
  static String clientSecret = "clientSecret";
  static String fullyQualifiedNamespace = "fullyQualifiedNamespace";
  static String authorityHost = "authorityHost";
  static AvroSerializer? avroSerializer;
  static String schemaDefinition =
      "{\"type\":\"record\",\"namespace\":\"damm.lab.eventhubs\",\"name\":\"Order\",\"fields\":[{\"name\":\"id\",\"type\":\"string\"},{\"name\":\"sourceId\",\"type\":\"string\"}]}";

  static int bottomNavigationBarSelectedIndex = 0;
}
