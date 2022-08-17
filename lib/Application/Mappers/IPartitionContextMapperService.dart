import 'package:flutter_azure_event_hubs/Domain/Entities/PartitionContext.dart';

abstract class IPartitionContextMapperService {
  Future<PartitionContext> fromJson(String jsonString);
  Future<PartitionContext> fromMap(Map<String, dynamic> map);
  Future<Iterable<PartitionContext>> fromJsonList(String jsonString);
  Future<String> toJson(PartitionContext partitionContext);
  Future<String> toJsonFromList(
      Iterable<PartitionContext> partitionContextList);
  Future<Map<String, dynamic>> toMap(PartitionContext partitionContext);
}
