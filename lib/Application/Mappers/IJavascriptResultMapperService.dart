import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptResult.dart';

abstract class IJavascriptResultMapperService {
  Future<JavascriptResult> fromJson(String jsonString);
  Future<JavascriptResult> fromMap(Map<String, dynamic> map);
  Future<Iterable<JavascriptResult>> fromJsonList(String jsonString);
  Future<String> toJson(JavascriptResult javascriptResult);
  Future<String> toJsonFromList(
      Iterable<JavascriptResult> javascriptResultList);
  Future<Map<String, dynamic>> toMap(JavascriptResult javascriptResult);
}
