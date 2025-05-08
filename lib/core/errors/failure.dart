abstract class Failure {
  final String message;

  Failure(this.message);
}

class DatabaseFailure extends Failure {
  DatabaseFailure(super.message);
}

class LocalDataSourceFailure extends Failure {
  LocalDataSourceFailure(super.message);
}

class RepositoryFailure extends Failure {
  RepositoryFailure(super.message);
}

class ServiceFailure extends Failure {
  ServiceFailure(super.message);
}
