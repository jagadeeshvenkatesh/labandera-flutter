import 'package:date_format/date_format.dart';

String convertDateFromString(String strDate) {
  DateTime todayDate = DateTime.parse(strDate);
  return formatDate(todayDate, [MM, ' ', dd, ', ', yyyy]);
}
