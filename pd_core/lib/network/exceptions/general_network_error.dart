
import '../../utils/utils.dart';
import 'exceptions.dart';

class GeneralError with LocalizedError {
  GeneralError() : super();

  @override
  String getLocalizedKey() => LocalizationKeys.errorGeneral;
}
