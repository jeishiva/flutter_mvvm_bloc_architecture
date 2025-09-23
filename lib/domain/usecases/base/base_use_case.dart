abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

// Stream use case interface for reactive data
abstract class StreamUseCase<Type, Params> {
  Stream<Type> call(Params params);
}
