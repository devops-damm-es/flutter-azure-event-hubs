import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_azure_event_hubs/Crosscutting/Mappers/IMessageContentMapperService.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/MessageContent.dart';
import '../../JsonMapperService.dart';

class MessageContentMapperService extends IMessageContentMapperService {
  @override
  Future<MessageContent> fromJson(String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecode, jsonString);
    var map = Map<String, dynamic>.from(result);
    return fromMap(map);
  }

  @override
  Future<MessageContent> fromMap(Map<String, dynamic> map) async {
    var result = new MessageContent(
        Uint8List.fromList(
            List<dynamic>.from(map["data"]).cast<int>().toList()),
        map["contentType"]);
    return Future.value(result);
  }

  @override
  Future<Iterable<MessageContent>> fromJsonList(String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecodeList, jsonString);
    var mappedResult = List<Map<String, dynamic>>.from(result);

    var returnList = new List<MessageContent>.empty(growable: true);
    for (var i = 0; i < mappedResult.length; i++) {
      var map = mappedResult[i];
      var messageContent = await fromMap(map);
      returnList.add(messageContent);
    }
    return Future.value(returnList);
  }

  @override
  Future<String> toJson(MessageContent messageContent) async {
    var map = await toMap(messageContent);
    return compute(JsonMapperService.jsonEncode, map);
  }

  @override
  Future<String> toJsonFromList(
      Iterable<MessageContent> messageContentList) async {
    var mapList = new List<Map<String, dynamic>>.empty(growable: true);
    for (var i = 0; i < messageContentList.length; i++) {
      var map = await toMap(messageContentList.elementAt(i));
      mapList.add(map);
    }
    return compute(JsonMapperService.jsonEncodeList, mapList);
  }

  @override
  Future<Map<String, dynamic>> toMap(MessageContent messageContent) async {
    var map = new Map<String, dynamic>();
    map["data"] = messageContent.data;
    map["contentType"] = messageContent.contentType;
    return Future.value(map);
  }
}
