import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pd_core/blocs/base/event/base_event.dart';
import 'package:pd_core/repository/base_repository.dart';

import '../../../core/core.dart';

mixin IBaseRepo <R> {
  void initRepo(R);
}

abstract class ILifecycle {

  void initStateDone();

  void didChangeDependencies();

  void didUpdateWidgets<W>(W oldWidget);

  void deactivate();

  void dispose();

  void emitState(BaseState s);
}

abstract class BaseBloc<E extends BaseEvent, S extends BaseState, V extends BaseView, R extends BaseRepo> extends Bloc<BaseEvent, BaseState> with ILifecycle, IBaseRepo{
  late R repo;

  late S baseState;
  late E baseEvent;
  late V view;

  BaseBloc({required this.baseEvent, required this.baseState}) : super(InitSate());

  @override
  void deactivate() {}

  @override
  void didChangeDependencies() {}

  @override
  void didUpdateWidgets<W>(W oldWidget) {}

  @override
  void initStateDone() {
    // view.initViewDone();
  }

  @override
  void initRepo(R) {
    repo = R;
  }

  @override
  void dispose() {}
}