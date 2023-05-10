import 'package:pd_core/network/model/model.dart';

extension ObjectExtension on Object {
  T fromJson<T extends BaseResponse>(Map e) => T.fromJson(e);
}