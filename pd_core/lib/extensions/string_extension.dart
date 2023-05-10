import 'dart:ui';

import '../resource/resource.dart';


late final RegExp _lineBreakHtmlTagRegex =
    RegExp('(\<br\/?\>)', multiLine: true);
late final RegExp _webLinkRegex = RegExp(
  r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+',
  multiLine: true,
);
final RegExp _validUrlProtocolRegex = RegExp(r'(https?|ftp)://');
final RegExp _wordsRegex = RegExp(r'(^\w{1})|(\s+\w{1})');

extension StringExt on String {
  Color get toColor {
    String data = replaceAll("#", "");
    if (data.length == 6) {
      data = "FF$data";
    }
    return Color(int.parse("0x$data"));
  }

  String get toLabel => "$this: ";

  String get toChinaMoney => "$this\¥";

  String get toPhoneLaunchUri => "tel:$this";

  String get toWebUrl =>
      startsWith(_validUrlProtocolRegex) ? this : "https://$this";

  String get capitalize =>
      length > 0 ? "${this[0].toUpperCase()}${substring(1)}" : '';

  String get capitalizeEachWords => replaceAllMapped(
    _wordsRegex,
        (match) => substring(match.start, match.end).toUpperCase(),
  );

  List<String> get dataValues =>
      trim().split(RegExp(r',\n?\s*'))..removeWhere((e) => e.isEmpty);

  String get fileNameWithExtension => substring(lastIndexOf('/') + 1);

  String get fileExtension => substring(lastIndexOf('.') + 1);

  String get displayFileExtension => fileExtension.toUpperCase();

  String get extensionOfFileFromDownloadLink => fileExtension;

  bool get isPngImageDownloadLink =>
      extensionOfFileFromDownloadLink.contains('png');

  bool get isNotPngImageDownloadLink => isPngImageDownloadLink == false;

  String get resolveLineBreakHtmlTag =>
      replaceAll(_lineBreakHtmlTagRegex, '\n');

  static int Function(String, String) comparator = (a, b) => a.compareTo(b);

  // static int Function(String, String) lowerCaseWithoutDiacriticComparator =
  //     (a, b) => removeDiacritics(a.toLowerCase()).compareTo(
  //           removeDiacritics(b.toLowerCase()),
  //         );

  bool get isStringNotUpdate => this == AppConstants.not_update;

  bool get containLoginWord => contains(AppConstants.login);

  List<TextPart> get splitedWebLinks {
    final List<RegExpMatch> matches = _webLinkRegex.allMatches(this).toList();

    if (matches.isEmpty) return const [];

    final List<TextPart> result = [];

    for (int strIndex = 0, matchIndex = 0;
        matchIndex < matches.length;
        strIndex = matches[matchIndex].end, matchIndex++) {
      final RegExpMatch match = matches[matchIndex];

      result.addAll([
        TextPart(
          isLink: false,
          text: substring(strIndex, match.start),
        ),
        TextPart(
          isLink: true,
          text: substring(match.start, match.end),
        ),
      ]);
    }

    result.add(
      TextPart(
        isLink: true,
        text: substring(matches.last.end, length),
      ),
    );

    return result;
  }

  bool toBool([bool defaultValue = false]) {
    if (toString().compareTo('1') == 0 ||
        toString().compareTo('true') == 0) {
      return true;
    } else if (toString().compareTo('0') == 0 ||
        toString().compareTo('false') == 0) {
      return false;
    }
    return defaultValue;
  }

  String revertBool([bool defaultValue = false]) {
    if (toString().compareTo('1') == 0 ||
        toString().compareTo('true') == 0) {
      return false.toString();
    } else if (toString().compareTo('0') == 0 ||
        toString().compareTo('false') == 0) {
      return true.toString();
    }
    return defaultValue.toString();
  }

  int toInt([int defaultValue=0]) {
    try {
      return int.parse(this);
    } catch (e) {
      return defaultValue;
    }
  }

  double toDouble([double defaultValue=0]) {
    try {
      return double.parse(this);
    } catch (e) {
      return defaultValue;
    }
  }
}

class TextPart {
  final bool isLink;
  final String text;

  TextPart({
    required this.isLink,
    required this.text,
  });
}

extension StringNullableExt on String? {
  String get emptyIfNull => this ?? '';
}
