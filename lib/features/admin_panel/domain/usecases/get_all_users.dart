import 'package:dartz/dartz.dart';
import 'package:eduflow/core/error/failures.dart';
import 'package:eduflow/core/usecase/usecase.dart';
import 'package:eduflow/features/user_management/domain/entities/user.dart';

import '../repositories/admin_repository.dart';

class GetAllUsersUseCase extends UseCase<List<User>, NoParams> {
  final AdminRepository repository;

  GetAllUsersUseCase(this.repository);

  @override
  Future<Either<Failure, List<User>>> call(NoParams params) {
    return repository.getAllUsers();
  }
}
