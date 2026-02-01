import 'package:flutter/material.dart';

import 'color_scheme.dart';

class DefaultWidgets {
  Container defaultContainer(BuildContext context, Widget child, totalWidth, totalHeight) {
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

  TextField defaultTextfield(BuildContext context, TextEditingController controllerx, IconData iconx, Function()? onTapx) {
    return TextField(
      controller: controllerx,
      readOnly: onTapx == null ? false : true,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        prefixIcon: Icon(iconx, color: Colors.grey, size: 20),
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
    );
  }
}
