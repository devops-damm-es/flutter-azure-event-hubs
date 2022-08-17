import 'package:flutter_azure_event_hubs/Domain/Entities/EventPosition.dart';

abstract class IEventPositionMapperService {
  Future<EventPosition> fromJson(String jsonString);
  Future<EventPosition> fromMap(Map<String, dynamic> map);
  Future<Iterable<EventPosition>> fromJsonList(String jsonString);
  Future<String> toJson(EventPosition eventPosition);
  Future<String> toJsonFromList(Iterable<EventPosition> eventPositionList);
  Future<Map<String, dynamic>> toMap(EventPosition eventPosition);
}
