import 'package:flutter_azure_event_hubs/Domain/Entities/ReceivedEventData.dart';

abstract class IReceivedEventDataMapperService {
  Future<ReceivedEventData> fromJson(String jsonString);
  Future<ReceivedEventData> fromMap(Map<String, dynamic> map);
  Future<Iterable<ReceivedEventData>> fromJsonList(String jsonString);
  Future<String> toJson(ReceivedEventData receivedEventData);
  Future<String> toJsonFromList(
      Iterable<ReceivedEventData> receivedEventDataList);
  Future<Map<String, dynamic>> toMap(ReceivedEventData receivedEventData);
}
