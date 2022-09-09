import 'dart:async';

import 'package:flutter_azure_event_hubs/Domain/Entities/AvroSerializer.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/AvroSerializerOptions.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/DeserializeOptions.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/MessageContent.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SchemaRegistryClient.dart';

abstract class IAvroSerializerApplicationService {
  Future<AvroSerializer> createAvroSerializer(
      SchemaRegistryClient schemaRegistryClient,
      {AvroSerializerOptions? avroSerializerOptions});
  Future<MessageContent> serialize(
      AvroSerializer avroSerializer, String jsonValue, String schema);
  Future<String> deserialize(
      AvroSerializer avroSerializer, MessageContent messageContent,
      {DeserializeOptions? deserializeOptions});
}
