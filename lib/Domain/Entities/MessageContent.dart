import 'dart:typed_data';

class MessageContent {
  final Uint8List data;
  final String contentType;
  MessageContent(this.data, this.contentType);
}
