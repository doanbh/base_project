import 'package:dio/dio.dart';
import 'package:pd_core/extensions/extensions.dart';

import '../core/core.dart';
import '../network/clients/clients.dart';
import '../network/exceptions/exceptions.dart';
import '../network/model/model.dart';

abstract class BaseRepo <V extends BaseView>{
  V? view;
  late CancelToken _cancelToken;

  BaseRepo() {
    _cancelToken = CancelToken();
  }

  setViewRepo(V viewRepo){
    view = viewRepo;
  }

  @override
  void dispose() {
    if (!_cancelToken.isCancelled) {
      _cancelToken.cancel();
    }
  }

  Future<T> requestNetwork<T extends BaseResponse>(Method method, {
    required String url,
    bool isShow = true,
    bool isClose = true,
    NetErrorCallback? onError,
    dynamic params,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) async {

     late T responseData;
    if (isShow) {
      view?.showProgress();
    }
    await RestClient.instance.requestNetwork(method, url,
      params: params,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken?? _cancelToken,
      onSuccess: (data) {
        if (isClose) {
          view?.closeProgress();
        }
        responseData = _generateOBJ<T>(data)!;
      },
      onError: (code, msg) {
        _onError(code, msg, onError);
      },
    );
    return responseData;
  }

  void asyncRequestNetwork<T>(Method method, {
    required String url,
    bool isShow = true,
    bool isClose = true,
    NetSuccessCallback<T?>? onSuccess,
    NetErrorCallback? onError,
    dynamic params,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) {
    if (isShow) {
      view?.showProgress();
    }
    RestClient.instance.asyncRequestNetwork<T>(method, url,
      params: params,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken?? _cancelToken,
      onSuccess: (data) {
        if (isClose) {
          view?.closeProgress();
        }
        onSuccess?.call(data);
      },
      onError: (code, msg) {
        _onError(code, msg, onError);
      },
    );
  }

  void _onError(int code, String msg, NetErrorCallback? onError) {
    view?.closeProgress();
    if (code != ExceptionHandle.cancel_error) {
      view?.showToast(msg);
    }
    if (onError != null) {
      onError(code, msg);
    }
  }


  T? _generateOBJ<T extends BaseResponse>(RequestResponse response) {
    if (T.toString() == 'String') {
      return response.toString() as T;
    } else if (T.toString() == 'Map<dynamic, dynamic>') {
      return response as T;
    } else {
      return T.fromJson<T>(response.json);
    }
  }
}

mixin IBaseRepo {
  void initRepo();
}

mixin BaseRepoMixin<R extends BaseRepo> implements IBaseRepo {

  late R repo;
  R createRepo();

  @override
  void initRepo() {
    repo = createRepo();
  }
}