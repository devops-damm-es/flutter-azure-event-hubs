import 'package:flutter_azure_event_hubs/Domain/Entities/IncomingEvent.dart';

abstract class IIncomingEventMapperService {
  Future<IncomingEvent> fromJson(String jsonString);
  Future<IncomingEvent> fromMap(Map<String, dynamic> map);
  Future<Iterable<IncomingEvent>> fromJsonList(String jsonString);
  Future<String> toJson(IncomingEvent incomingEvent);
  Future<String> toJsonFromList(Iterable<IncomingEvent> incomingEventList);
  Future<Map<String, dynamic>> toMap(IncomingEvent incomingEvent);
}
