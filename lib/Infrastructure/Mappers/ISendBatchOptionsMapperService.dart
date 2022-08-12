import 'package:flutter_azure_event_hubs/Domain/Entities/SendBatchOptions.dart';

abstract class ISendBatchOptionsMapperService {
  Future<SendBatchOptions> fromJson(String jsonString);
  Future<SendBatchOptions> fromMap(Map<String, dynamic> map);
  Future<Iterable<SendBatchOptions>> fromJsonList(String jsonString);
  Future<String> toJson(SendBatchOptions sendBatchOptions);
  Future<String> toJsonFromList(
      Iterable<SendBatchOptions> sendBatchOptionsList);
  Future<Map<String, dynamic>> toMap(SendBatchOptions sendBatchOptions);
}
