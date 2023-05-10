import 'package:dio/dio.dart';

import '../../utils/utils.dart';
import 'exceptions.dart';

class GeneralNetworkError extends NetworkError {
  GeneralNetworkError(DioError dioError) : super(dioError);

  @override
  String getLocalizedKey() => LocalizationKeys.errorGeneral;

  @override
  String? get getErrorCode => null;
}
