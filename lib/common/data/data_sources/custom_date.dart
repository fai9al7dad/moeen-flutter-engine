class CustomDate {
  String getFormattedDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  // get date from string
  DateTime getDateFromString(String date) {
    return DateTime.parse(date);
  }

  String getFormattedDateFromString(String date) {
    return getFormattedDate(DateTime.parse(date));
  }

  String getFormattedDateFromTimestamp(int timestamp) {
    return getFormattedDate(DateTime.fromMillisecondsSinceEpoch(timestamp));
  }

  String getFormattedDateFromTimestampString(String timestamp) {
    return getFormattedDateFromTimestamp(int.parse(timestamp));
  }

  String getFormattedTime(DateTime date) {
    return "${date.hour}:${date.minute}";
  }

  String getFormattedTimeFromString(String date) {
    return getFormattedTime(DateTime.parse(date));
  }
}
