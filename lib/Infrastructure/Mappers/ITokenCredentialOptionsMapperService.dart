import 'package:flutter_azure_event_hubs/Domain/Entities/TokenCredentialOptions.dart';

abstract class ITokenCredentialOptionsMapperService {
  Future<TokenCredentialOptions> fromJson(String jsonString);
  Future<TokenCredentialOptions> fromMap(Map<String, dynamic> map);
  Future<Iterable<TokenCredentialOptions>> fromJsonList(String jsonString);
  Future<String> toJson(TokenCredentialOptions tokenCredentialOptions);
  Future<String> toJsonFromList(
      Iterable<TokenCredentialOptions> tokenCredentialOptionsList);
  Future<Map<String, dynamic>> toMap(
      TokenCredentialOptions tokenCredentialOptions);
}
