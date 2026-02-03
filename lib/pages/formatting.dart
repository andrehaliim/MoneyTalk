import 'package:intl/intl.dart';

class Formatting {
  String formatRupiah(double nilai) {
    if (nilai == 0) return '0';
    return NumberFormat('#,##0', "en_US").format(nilai);
  }

}