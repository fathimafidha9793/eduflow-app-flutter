import 'package:dartz/dartz.dart';
import 'package:eduflow/core/error/failures.dart';
import 'package:eduflow/core/usecase/usecase.dart';
import 'package:eduflow/features/admin_panel/domain/entities/admin_stats.dart';
import 'package:eduflow/features/admin_panel/domain/repositories/admin_repository.dart';

class GetAdminStatsUseCase extends UseCase<AdminStats, NoParams> {
  final AdminRepository repository;

  GetAdminStatsUseCase(this.repository);

  @override
  Future<Either<Failure, AdminStats>> call(NoParams params) async {
    return repository.getAdminStats();
  }
}
