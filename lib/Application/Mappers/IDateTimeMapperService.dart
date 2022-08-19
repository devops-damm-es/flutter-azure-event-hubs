abstract class IDateTimeMapperService {
  Future<String> toStringDateTimeUtc(DateTime dateTime);
  Future<DateTime> toDateTimeUtc(String stringDateTime);
}
