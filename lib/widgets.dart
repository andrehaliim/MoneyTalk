import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'color_scheme.dart';

class DefaultWidgets {
  final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter.currency(
    locale: 'en',
    decimalDigits: 0,
    symbol: '',
  );

  Container defaultContainer(BuildContext context, Widget child, double? totalWidth, double?totalHeight) {
    return Container(
      width: totalWidth,
      height: totalHeight,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: moneyTalkColorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: child,
    );
  }

  TextField defaultTextfield(BuildContext context, TextEditingController controllerx, IconData? iconx, Function()? onTapx, Widget? widgetx) {
    return TextField(
      controller: controllerx,
      readOnly: onTapx == null ? false : true,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
      textAlign: iconx == null ? TextAlign.right : TextAlign.left,
      decoration: InputDecoration(
        prefixIcon: iconx == null ? null : Icon(iconx, color: Colors.grey, size: 20),
        prefix: widgetx,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withAlpha(50), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withAlpha(50), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withAlpha(50), width: 2),
        ),
      ),
      onTap: onTapx,
      keyboardType: iconx == null ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
      inputFormatters: iconx == null ? <TextInputFormatter>[_formatter] : [],
    );
  }
}
