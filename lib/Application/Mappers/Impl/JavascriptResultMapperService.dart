import 'package:flutter/foundation.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/IJavascriptResultMapperService.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptResult.dart';
import '../../../Crosscutting/JsonMapperService.dart';

class JavascriptResultMapperService extends IJavascriptResultMapperService {
  @override
  Future<JavascriptResult> fromJson(String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecode, jsonString);
    var map = Map<String, dynamic>.from(result);
    return fromMap(map);
  }

  @override
  Future<JavascriptResult> fromMap(Map<String, dynamic> map) async {
    var result = new JavascriptResult(map["id"], map["javascriptTransactionId"],
        map["success"], map["result"]);
    return Future.value(result);
  }

  @override
  Future<Iterable<JavascriptResult>> fromJsonList(String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecodeList, jsonString);
    var mappedResult = List<Map<String, dynamic>>.from(result);

    var returnList = new List<JavascriptResult>.empty(growable: true);
    for (var i = 0; i < mappedResult.length; i++) {
      var map = mappedResult[i];
      var javascriptResult = await fromMap(map);
      returnList.add(javascriptResult);
    }
    return Future.value(returnList);
  }

  @override
  Future<String> toJson(JavascriptResult javascriptResult) async {
    var map = await toMap(javascriptResult);
    return compute(JsonMapperService.jsonEncode, map);
  }

  @override
  Future<String> toJsonFromList(
      Iterable<JavascriptResult> javascriptResultList) async {
    var mapList = new List<Map<String, dynamic>>.empty(growable: true);
    for (var i = 0; i < javascriptResultList.length; i++) {
      var map = await toMap(javascriptResultList.elementAt(i));
      mapList.add(map);
    }
    return compute(JsonMapperService.jsonEncodeList, mapList);
  }

  @override
  Future<Map<String, dynamic>> toMap(JavascriptResult javascriptResult) async {
    var map = new Map<String, dynamic>();
    map["id"] = javascriptResult.id;
    map["javascriptTransaction"] = javascriptResult.javascriptTransactionId;
    map["success"] = javascriptResult.success;
    map["result"] = javascriptResult.result;
    return Future.value(map);
  }
}
