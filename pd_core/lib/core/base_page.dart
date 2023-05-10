import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pd_core/blocs/base/bloc/base_bloc.dart';
import '../presentation/dialog/dialog.dart';
import 'base_state_view.dart';
import '../../utils/utils.dart';

mixin BasePageMixin<T extends StatefulWidget, P extends BaseBloc> on State<T> implements BaseView {

  late P presenter;

  P createPresenter();

  @override
  BuildContext getContext() {
    return context;
  }
  
  @override
  void closeProgress() {
    if (mounted && _isShowDialog) {
      _isShowDialog = false;
      Navigator.pop(context);
    }
  }

  bool _isShowDialog = false;

  @override
  void showProgress() {
    if (mounted && !_isShowDialog) {
      _isShowDialog = true;
      try {
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          barrierColor: const Color(0x00FFFFFF),
          builder:(_) {
            return WillPopScope(
              onWillPop: () async {
                _isShowDialog = false;
                return Future.value(true);
              },
              child: buildProgress(),
            );
          },
        );
      } catch(e) {
        debugPrint(e.toString());
      }
    }
  }

  @override
  void showCustomProgress({Widget? loader}) {
    if (mounted && !_isShowDialog) {
      _isShowDialog = true;
      try {
        showTransparentDialog(
            context: context,
            barrierDismissible: false,
            builder:(_) {
              return WillPopScope(
                onWillPop: () async {
                  _isShowDialog = false;
                  return Future.value(true);
                },
                child: loader!,
              );
            }
        );
      } catch(e) {
        print(e);
      }
    }
  }

  @override
  void showDialogCustom(Widget child, {String title = "365"}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BaseCustomDialog(
            title: title,
            child: child,
            onPressed: () {
              Navigator.pop(context);
            },
          );
        });
  }

  @override
  void showToast(String string) {
    // Toast.show(string);
  }
  
  Widget buildProgress() => const ProgressDialog(hintText: 'Đang tải...');

  @override
  void didChangeDependencies() {
    presenter.didChangeDependencies();
    logger.debug('$T ==> didChangeDependencies');
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    presenter.dispose();
    logger.debug('$T ==> dispose');
    super.dispose();
  }

  @override
  void deactivate() {
    presenter.deactivate();
    logger.debug('$T ==> deactivate');
    super.deactivate();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    presenter.didUpdateWidgets<T>(oldWidget);
    logger.debug('$T ==> didUpdateWidgets');
    super.didUpdateWidget(oldWidget);

  }

  @override
  void initState() {
    logger.debug('$T ==> initState');
    presenter = createPresenter();
    presenter.view = this;
    // print("view: ${presenter?.view}");
    presenter.initStateDone();
    super.initState();
  }
  
}
