// import 'package:eduflow/core/usecase/usecase.dart';
// import 'package:eduflow/features/reminder/domain/entities/reminder.dart.dart';
// import '../../../../core/utils/typedef.dart';
// import '../repositories/reminder_repository.dart';

// class UpdateReminderUseCase implements UseCase<Reminder, UpdateReminderParams> {
//   final ReminderRepository repository;

//   UpdateReminderUseCase(this.repository);

//   @override
//   ReminderResult call(UpdateReminderParams params) {
//     return repository.updateReminder(params.reminder);
//   }
// }

// class UpdateReminderParams {
//   final Reminder reminder;

//   const UpdateReminderParams({required this.reminder});
// }

import 'package:eduflow/core/usecase/usecase.dart';
import 'package:eduflow/features/reminder/domain/entities/reminder.dart';
import '../../../../core/utils/typedef.dart';
import '../repositories/reminder_repository.dart';

class UpdateReminderUseCase implements UseCase<Reminder, UpdateReminderParams> {
  final ReminderRepository repository;

  UpdateReminderUseCase(this.repository);

  @override
  ReminderResult call(UpdateReminderParams params) {
    return repository.updateReminder(params.reminder);
  }
}

class UpdateReminderParams {
  final Reminder reminder;
  const UpdateReminderParams({required this.reminder});
}
