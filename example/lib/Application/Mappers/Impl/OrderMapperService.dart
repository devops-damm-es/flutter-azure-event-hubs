import 'package:flutter/foundation.dart';
import 'package:flutter_azure_event_hubs_example/Application/Mappers/IOrderMapperService.dart';
import 'package:flutter_azure_event_hubs_example/Domain/Entities/Order.dart';
import '../../../Crosscutting/JsonMapperService.dart';

class OrderMapperService extends IOrderMapperService {
  @override
  Future<Order> fromJson(String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecode, jsonString);
    var map = Map<String, dynamic>.from(result);
    return fromMap(map);
  }

  @override
  Future<Order> fromMap(Map<String, dynamic> map) async {
    var result = new Order(map["id"], map["sourceId"]);
    return Future.value(result);
  }

  @override
  Future<Iterable<Order>> fromJsonList(String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecodeList, jsonString);
    var mappedResult = List<Map<String, dynamic>>.from(result);

    var returnList = new List<Order>.empty(growable: true);
    for (var i = 0; i < mappedResult.length; i++) {
      var map = mappedResult[i];
      var order = await fromMap(map);
      returnList.add(order);
    }
    return Future.value(returnList);
  }

  @override
  Future<String> toJson(Order order) async {
    var map = await toMap(order);
    return compute(JsonMapperService.jsonEncode, map);
  }

  @override
  Future<String> toJsonFromList(Iterable<Order> orderList) async {
    var mapList = new List<Map<String, dynamic>>.empty(growable: true);
    for (var i = 0; i < orderList.length; i++) {
      var map = await toMap(orderList.elementAt(i));
      mapList.add(map);
    }
    return compute(JsonMapperService.jsonEncodeList, mapList);
  }

  @override
  Future<Map<String, dynamic>> toMap(Order order) async {
    var map = new Map<String, dynamic>();
    map["id"] = order.id;
    map["sourceId"] = order.sourceId;
    return Future.value(map);
  }
}
