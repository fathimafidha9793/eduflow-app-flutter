import 'package:dartz/dartz.dart';
import 'package:eduflow/core/error/failures.dart';
import 'package:eduflow/features/resources/domain/entities/file_resource.dart';
import 'package:eduflow/features/resources/domain/repositories/resource_repository.dart';

class RestoreResourceUsecase {
  final ResourceRepository repository;
  RestoreResourceUsecase(this.repository);

  Future<Either<Failure, void>> call(FileResource resource) {
    return repository.restore(resource);
  }
}
