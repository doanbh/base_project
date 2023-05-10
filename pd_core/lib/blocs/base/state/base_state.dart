import 'package:equatable/equatable.dart';

abstract class BaseState extends Equatable {
  const BaseState();

  @override
  List<Object> get props => [];
}

class InitSate extends BaseState {}

class LoadingState extends BaseState {
}

class LoadSuccessState extends BaseState {
  final dynamic model;

  const LoadSuccessState({required this.model});

  @override
  List<Object> get props => [model];
}

class LoadFailedState extends BaseState {
  final dynamic error;

  const LoadFailedState({required this.error});

  @override
  List<Object> get props => [error];
}