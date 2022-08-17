import 'package:flutter_azure_event_hubs/Domain/Entities/SubscribeOptions.dart';

abstract class ISubscribeOptionsMapperService {
  Future<SubscribeOptions> fromJson(String jsonString);
  Future<SubscribeOptions> fromMap(Map<String, dynamic> map);
  Future<Iterable<SubscribeOptions>> fromJsonList(String jsonString);
  Future<String> toJson(SubscribeOptions subscribeOptions);
  Future<String> toJsonFromList(
      Iterable<SubscribeOptions> subscribeOptionsList);
  Future<Map<String, dynamic>> toMap(SubscribeOptions subscribeOptions);
}
