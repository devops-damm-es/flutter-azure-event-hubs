import 'package:flutter_azure_event_hubs/Domain/Entities/DeserializeOptions.dart';

abstract class IDeserializeOptionsMapperService {
  Future<DeserializeOptions> fromJson(String jsonString);
  Future<DeserializeOptions> fromMap(Map<String, dynamic> map);
  Future<Iterable<DeserializeOptions>> fromJsonList(String jsonString);
  Future<String> toJson(DeserializeOptions deserializeOptions);
  Future<String> toJsonFromList(
      Iterable<DeserializeOptions> deserializeOptionsList);
  Future<Map<String, dynamic>> toMap(DeserializeOptions deserializeOptions);
}
