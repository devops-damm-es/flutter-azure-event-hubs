import 'package:flutter_azure_event_hubs/Domain/Entities/AvroSerializerOptions.dart';

abstract class IAvroSerializerOptionsMapperService {
  Future<AvroSerializerOptions> fromJson(String jsonString);
  Future<AvroSerializerOptions> fromMap(Map<String, dynamic> map);
  Future<Iterable<AvroSerializerOptions>> fromJsonList(String jsonString);
  Future<String> toJson(AvroSerializerOptions avroSerializerOptions);
  Future<String> toJsonFromList(
      Iterable<AvroSerializerOptions> avroSerializerOptionsList);
  Future<Map<String, dynamic>> toMap(
      AvroSerializerOptions avroSerializerOptions);
}
