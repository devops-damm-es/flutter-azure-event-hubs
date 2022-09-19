class ReceivedEventData {
  final dynamic body;
  final String? contentType;
  final DateTime enqueuedTimeUtc;
  final String? partitionKey;
  final String offset;
  final int sequenceNumber;
  ReceivedEventData(this.body, this.contentType, this.enqueuedTimeUtc,
      this.partitionKey, this.offset, this.sequenceNumber);
}
