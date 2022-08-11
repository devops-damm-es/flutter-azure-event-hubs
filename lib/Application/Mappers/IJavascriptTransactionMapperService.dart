import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';

abstract class IJavascriptTransactionMapperService {
  Future<JavascriptTransaction> fromJson(String jsonString);
  Future<JavascriptTransaction> fromMap(Map<String, dynamic> map);
  Future<Iterable<JavascriptTransaction>> fromJsonList(String jsonString);
  Future<String> toJson(JavascriptTransaction javascriptTransaction);
  Future<String> toJsonFromList(
      Iterable<JavascriptTransaction> javascriptTransactionList);
  Future<Map<String, dynamic>> toMap(
      JavascriptTransaction javascriptTransaction);
}
