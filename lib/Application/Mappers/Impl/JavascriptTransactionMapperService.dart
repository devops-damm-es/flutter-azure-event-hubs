import 'package:flutter/foundation.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/IJavascriptTransactionMapperService.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';
import '../../../Crosscutting/JsonMapperService.dart';

class JavascriptTransactionMapperService
    extends IJavascriptTransactionMapperService {
  @override
  Future<JavascriptTransaction> fromJson(String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecode, jsonString);
    var map = Map<String, dynamic>.from(result);
    return fromMap(map);
  }

  @override
  Future<JavascriptTransaction> fromMap(Map<String, dynamic> map) async {
    var result = new JavascriptTransaction(map["id"], map["javascriptCode"]);
    return Future.value(result);
  }

  @override
  Future<Iterable<JavascriptTransaction>> fromJsonList(
      String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecodeList, jsonString);
    var mappedResult = List<Map<String, dynamic>>.from(result);

    var returnList = new List<JavascriptTransaction>.empty(growable: true);
    for (var i = 0; i < mappedResult.length; i++) {
      var map = mappedResult[i];
      var javascriptTransaction = await fromMap(map);
      returnList.add(javascriptTransaction);
    }
    return Future.value(returnList);
  }

  @override
  Future<String> toJson(JavascriptTransaction javascriptTransaction) async {
    var map = await toMap(javascriptTransaction);
    return compute(JsonMapperService.jsonEncode, map);
  }

  @override
  Future<String> toJsonFromList(
      Iterable<JavascriptTransaction> javascriptTransactionList) async {
    var mapList = new List<Map<String, dynamic>>.empty(growable: true);
    for (var i = 0; i < javascriptTransactionList.length; i++) {
      var map = await toMap(javascriptTransactionList.elementAt(i));
      mapList.add(map);
    }
    return compute(JsonMapperService.jsonEncodeList, mapList);
  }

  @override
  Future<Map<String, dynamic>> toMap(
      JavascriptTransaction javascriptTransaction) async {
    var map = new Map<String, dynamic>();
    map["id"] = javascriptTransaction.id;
    map["javascriptCode"] = javascriptTransaction.javascriptCode;
    return Future.value(map);
  }
}
