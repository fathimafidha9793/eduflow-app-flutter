// import 'package:eduflow/core/usecase/usecase.dart';
// import '../../../../core/utils/typedef.dart';
// import '../repositories/reminder_repository.dart';

// class DeleteReminderUseCase implements UseCase<void, String> {
//   final ReminderRepository repository;

//   DeleteReminderUseCase(this.repository);

//   @override
//   ResultVoid call(String reminderId) {
//     return repository.deleteReminder(reminderId);
//   }
// }

import 'package:eduflow/core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../repositories/reminder_repository.dart';

class DeleteReminderUseCase implements UseCase<void, String> {
  final ReminderRepository repository;

  DeleteReminderUseCase(this.repository);

  @override
  ResultVoid call(String reminderId) {
    return repository.deleteReminder(reminderId);
  }
}
