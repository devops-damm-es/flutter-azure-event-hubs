import 'package:flutter_azure_event_hubs/Application/IAvroSerializerApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/IClientSecretCredentialApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/IEventHubConsumerClientApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/IEventHubProducerClientApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/ISchemaRegistryClientApplicationService.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/AvroSerializer.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/AvroSerializerOptions.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SchemaDescription.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/TokenCredentialOptions.dart';
import 'package:flutter_azure_event_hubs_example/Application/Mappers/IOrderMapperService.dart';

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
  static IOrderMapperService? orderMapperService;
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

  static Future<AvroSerializer> getAvroSerializer() async {
    if (Configuration.avroSerializer == null) {
      var clientSecretCredential = await Configuration
          .clientSecretCredentialApplicationService!
          .createClientSecretCredential(Configuration.tenantId,
              Configuration.clientId, Configuration.clientSecret,
              tokenCredentialOptions:
                  new TokenCredentialOptions(Configuration.authorityHost));

      var schemaRegistryClient = await Configuration
          .schemaRegistryClientApplicationService!
          .createSchemaRegistryClient(
              Configuration.fullyQualifiedNamespace, clientSecretCredential);

      var schemaDescription = SchemaDescription("groupschema1",
          "damm.lab.eventhubs.Order", "avro", Configuration.schemaDefinition);

      Configuration.avroSerializer = await Configuration
          .avroSerializerApplicationService!
          .createAvroSerializer(schemaRegistryClient,
              avroSerializerOptions: new AvroSerializerOptions(
                  false, schemaDescription.groupName));
    }
    return Future.value(Configuration.avroSerializer!);
  }
}
