import 'dart:async';

import 'package:flutter_azure_event_hubs/Domain/Entities/AvroSerializer.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/AvroSerializerOptions.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SchemaRegistryClient.dart';

abstract class IAvroSerializerApplicationService {
  Future<AvroSerializer> createAvroSerializer(
      SchemaRegistryClient schemaRegistryClient,
      {AvroSerializerOptions? avroSerializerOptions});
}
