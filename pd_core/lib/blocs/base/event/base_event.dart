import '../../../repository/repository.dart';

class BaseEvent<R extends BaseRepo> with BaseRepoMixin<R>{

  @override
  R createRepo() {
    // TODO: implement createRepo
    throw UnimplementedError();
  }

}