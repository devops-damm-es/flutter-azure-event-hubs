import 'dart:convert';

class JsonMapperService {
  static Map<String, dynamic> jsonDecode(String jsonString) {
    return json.decode(jsonString);
  }

  static dynamic jsonDecodeList(String jsonString) {
    return json.decode(jsonString);
  }

  static String jsonEncode(Map<String, dynamic> map) {
    return json.encode(map);
  }

  static String jsonEncodeList(dynamic mapList) {
    return json.encode(mapList);
  }
}
