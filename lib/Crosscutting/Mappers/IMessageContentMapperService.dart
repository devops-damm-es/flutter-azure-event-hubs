import 'package:flutter_azure_event_hubs/Domain/Entities/MessageContent.dart';

abstract class IMessageContentMapperService {
  Future<MessageContent> fromJson(String jsonString);
  Future<MessageContent> fromMap(Map<String, dynamic> map);
  Future<Iterable<MessageContent>> fromJsonList(String jsonString);
  Future<String> toJson(MessageContent messageContent);
  Future<String> toJsonFromList(Iterable<MessageContent> messageContentList);
  Future<Map<String, dynamic>> toMap(MessageContent messageContent);
}
