import 'dart:io';

import 'package:dio/dio.dart';

import '../../utils/utils.dart';
import 'exceptions.dart';

class BadRequestError extends NetworkError {
  static const statusCode = HttpStatus.badRequest;

  BadRequestError(DioError dioError, {String? statusCode}) : super(dioError, statusCodeValue: statusCode);

  @override
  String getLocalizedKey() => LocalizationKeys.errorBadRequest;

  @override
  String? get getErrorCode {
    if (statusCodeValue == null) return '$statusCode';
    return '$statusCode [$statusCodeValue]';
  }

  static NetworkError parseError(DioError err) {
    final dynamic data = err.response?.data;
    if (data is! Map) return BadRequestError(err);
    if (!data.containsKey('code')) return BadRequestError(err);
    final code = data['code'] as String;
    switch (code) {
      default:
        return BadRequestError(err);
    }
  }
}
