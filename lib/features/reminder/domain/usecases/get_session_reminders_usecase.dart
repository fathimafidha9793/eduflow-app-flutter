import 'package:eduflow/core/usecase/usecase.dart';
import 'package:eduflow/features/reminder/domain/entities/reminder.dart';
import '../../../../core/utils/typedef.dart';
import '../repositories/reminder_repository.dart';

class GetSessionRemindersUseCase implements UseCase<List<Reminder>, String> {
  final ReminderRepository repository;

  GetSessionRemindersUseCase(this.repository);

  @override
  RemindersResult call(String sessionId) {
    return repository.getRemindersBySessionId(sessionId);
  }
}
