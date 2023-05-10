import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/theme.dart';

extension IconExtension on Icon {
  Icon autoDirection() {
    if (AppTheme.textDirection == TextDirection.ltr) return this;
    if (icon == Icons.chevron_left) {
      return Icon(
        Icons.chevron_left,
        color: color,
        textDirection: textDirection,
        size: size,
        key: key,
        semanticLabel: semanticLabel,
      );
    } else if (icon == CupertinoIcons.chevron_left) {
      return Icon(
        CupertinoIcons.chevron_right,
        color: color,
        textDirection: textDirection,
        size: size,
        key: key,
        semanticLabel: semanticLabel,
      );
    }
    return this;
  }
}
