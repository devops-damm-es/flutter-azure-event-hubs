import 'package:flutter/foundation.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/TokenCredentialOptions.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/ITokenCredentialOptionsMapperService.dart';
import '../../../Crosscutting/JsonMapperService.dart';

class TokenCredentialOptionsMapperService
    extends ITokenCredentialOptionsMapperService {
  @override
  Future<TokenCredentialOptions> fromJson(String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecode, jsonString);
    var map = Map<String, dynamic>.from(result);
    return fromMap(map);
  }

  @override
  Future<TokenCredentialOptions> fromMap(Map<String, dynamic> map) async {
    var result = new TokenCredentialOptions(map["authorityHost"]);
    return Future.value(result);
  }

  @override
  Future<Iterable<TokenCredentialOptions>> fromJsonList(
      String jsonString) async {
    var result = await compute(JsonMapperService.jsonDecodeList, jsonString);
    var mappedResult = List<Map<String, dynamic>>.from(result);

    var returnList = new List<TokenCredentialOptions>.empty(growable: true);
    for (var i = 0; i < mappedResult.length; i++) {
      var map = mappedResult[i];
      var tokenCredentialOptions = await fromMap(map);
      returnList.add(tokenCredentialOptions);
    }
    return Future.value(returnList);
  }

  @override
  Future<String> toJson(TokenCredentialOptions tokenCredentialOptions) async {
    var map = await toMap(tokenCredentialOptions);
    return compute(JsonMapperService.jsonEncode, map);
  }

  @override
  Future<String> toJsonFromList(
      Iterable<TokenCredentialOptions> tokenCredentialOptionsList) async {
    var mapList = new List<Map<String, dynamic>>.empty(growable: true);
    for (var i = 0; i < tokenCredentialOptionsList.length; i++) {
      var map = await toMap(tokenCredentialOptionsList.elementAt(i));
      mapList.add(map);
    }
    return compute(JsonMapperService.jsonEncodeList, mapList);
  }

  @override
  Future<Map<String, dynamic>> toMap(
      TokenCredentialOptions tokenCredentialOptions) async {
    var map = new Map<String, dynamic>();
    if (tokenCredentialOptions.authorityHost != null) {
      map["authorityHost"] = tokenCredentialOptions.authorityHost;
    }
    return Future.value(map);
  }
}
