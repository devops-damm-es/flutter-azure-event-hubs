class ReceivedEventData {
  final dynamic body;
  final DateTime enqueuedTimeUtc;
  final String? partitionKey;
  final int offset;
  final int sequenceNumber;
  ReceivedEventData(this.body, this.enqueuedTimeUtc, this.partitionKey,
      this.offset, this.sequenceNumber);
}
