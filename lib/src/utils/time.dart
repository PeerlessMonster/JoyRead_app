import 'package:intl/intl.dart';

DateTime parse(String utcMillisecondsSinceEpoch) =>
    DateTime.fromMillisecondsSinceEpoch(int.parse(utcMillisecondsSinceEpoch),
        isUtc: true);

final _dateFormatter = DateFormat.yMd().add_jm();

String formatToLocal(DateTime utc) => _dateFormatter.format(utc.toLocal());
