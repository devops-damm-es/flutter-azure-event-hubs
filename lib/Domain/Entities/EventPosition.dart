class EventPosition {
  final dynamic offset;
  final bool? isInclusive;
  final int? enqueuedOn;
  final int? sequenceNumber;
  EventPosition(
      this.offset, this.isInclusive, this.enqueuedOn, this.sequenceNumber);
}
