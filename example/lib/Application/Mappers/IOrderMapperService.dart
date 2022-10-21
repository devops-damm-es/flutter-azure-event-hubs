import 'package:flutter_azure_event_hubs_example/Domain/Entities/Order.dart';

abstract class IOrderMapperService {
  Future<Order> fromJson(String jsonString);
  Future<Order> fromMap(Map<String, dynamic> map);
  Future<Iterable<Order>> fromJsonList(String jsonString);
  Future<String> toJson(Order order);
  Future<String> toJsonFromList(Iterable<Order> orderList);
  Future<Map<String, dynamic>> toMap(Order order);
}
