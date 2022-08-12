import 'package:flutter_azure_event_hubs/Domain/Entities/EventData.dart';

abstract class IEventDataMapperService {
  Future<EventData> fromJson(String jsonString);
  Future<EventData> fromMap(Map<String, dynamic> map);
  Future<Iterable<EventData>> fromJsonList(String jsonString);
  Future<String> toJson(EventData eventData);
  Future<String> toJsonFromList(Iterable<EventData> eventDataList);
  Future<Map<String, dynamic>> toMap(EventData eventData);
}
