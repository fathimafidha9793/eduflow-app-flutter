import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eduflow/config/theme/bloc/theme_cubit.dart';
import 'package:eduflow/features/admin_panel/data/datasources/admin_local_datasource.dart';
import 'package:eduflow/features/admin_panel/data/datasources/admin_remote_datasource.dart';
import 'package:eduflow/features/admin_panel/data/repositories/admin_repository_impl.dart';
import 'package:eduflow/features/admin_panel/domain/repositories/admin_repository.dart';
import 'package:eduflow/features/admin_panel/domain/usecases/delete_user_admin.dart';
import 'package:eduflow/features/admin_panel/domain/usecases/get_admin_stats.dart';
import 'package:eduflow/features/admin_panel/domain/usecases/get_all_users.dart';
import 'package:eduflow/features/admin_panel/presentation/bloc/admin_analytics/admin_analytics_bloc.dart';
import 'package:eduflow/features/admin_panel/presentation/bloc/admin_dashboard/admin_dashboard_bloc.dart';
import 'package:eduflow/features/admin_panel/presentation/bloc/admin_users/admin_users_bloc.dart';
import 'package:eduflow/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:eduflow/core/network/network_info.dart';
import 'package:eduflow/core/utils/logger.dart';
import 'package:eduflow/features/admin_panel/data/datasources/admin_analytics_remote_ds.dart';
import 'package:eduflow/features/admin_panel/data/repositories/admin_analytics_repository_impl.dart';
import 'package:eduflow/features/admin_panel/domain/repositories/admin_analytics_repository.dart';
import 'package:eduflow/features/admin_panel/domain/usecases/get_all_user_progress.dart';
import 'package:eduflow/features/admin_panel/domain/usecases/get_user_progress.dart';
import 'package:eduflow/features/analytics/data/datasources/analytics_local_datasource.dart';
import 'package:eduflow/features/analytics/data/datasources/analytics_remote_datasource.dart';
import 'package:eduflow/features/analytics/data/models/analytics_insight_model.dart';
import 'package:eduflow/features/analytics/data/models/progress_snapshot_model.dart';
import 'package:eduflow/features/analytics/data/models/progress_trends_model.dart';
import 'package:eduflow/features/analytics/data/models/study_goal_model.dart';
import 'package:eduflow/features/analytics/data/repositories/analytics_repository_impl.dart';
import 'package:eduflow/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:eduflow/features/analytics/domain/usecases/create_study_goal_usecase.dart';
import 'package:eduflow/features/analytics/domain/usecases/delete_study_goal_usecase.dart';
import 'package:eduflow/features/analytics/domain/usecases/get_active_goals_usecase.dart';
import 'package:eduflow/features/analytics/domain/usecases/load_analytics_overview_usecase.dart';
import 'package:eduflow/features/analytics/domain/usecases/update_study_goal_usecase.dart';
import 'package:eduflow/features/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:eduflow/features/reminder/data/datasources/reminder_local_datasource.dart';
import 'package:eduflow/features/reminder/data/datasources/reminder_remote_datasource.dart';
import 'package:eduflow/features/reminder/data/models/reminder_model.dart';
import 'package:eduflow/features/reminder/data/repositories/reminder_repository_impl.dart';
import 'package:eduflow/features/reminder/domain/repositories/reminder_repository.dart';
import 'package:eduflow/features/reminder/domain/usecases/create_reminder_usecase.dart';
import 'package:eduflow/features/reminder/domain/usecases/delete_reminder_usecase.dart';
import 'package:eduflow/features/reminder/domain/usecases/get_reminders_usecase.dart';
import 'package:eduflow/features/reminder/domain/usecases/get_session_reminders_usecase.dart';
import 'package:eduflow/features/reminder/domain/usecases/get_task_reminders_usecase.dart';
import 'package:eduflow/features/reminder/domain/usecases/mark_reminder_triggered_usecase.dart';
import 'package:eduflow/features/reminder/domain/usecases/toggle_reminder_usecase.dart';
import 'package:eduflow/features/reminder/domain/usecases/update_reminder_usecase.dart';
import 'package:eduflow/features/reminder/presentation/bloc/reminder_bloc.dart';
import 'package:eduflow/features/resources/data/datasources/resource_local_datasource.dart';
import 'package:eduflow/features/resources/data/datasources/resource_remote_datasource.dart';
import 'package:eduflow/features/resources/data/datasources/resource_storage_datasource.dart';
import 'package:eduflow/features/resources/data/models/file_resource_model.dart';
import 'package:eduflow/features/resources/data/repositories/resource_repository_impl.dart';
import 'package:eduflow/features/resources/domain/repositories/resource_repository.dart';
import 'package:eduflow/features/resources/domain/usecases/get_resources_by_subject.dart';
import 'package:eduflow/features/resources/domain/usecases/get_resources_by_user.dart';
import 'package:eduflow/features/resources/domain/usecases/restore_resource.dart';
import 'package:eduflow/features/resources/domain/usecases/soft_delete_resource.dart';
import 'package:eduflow/features/resources/domain/usecases/toggle_favorite_resource.dart';
import 'package:eduflow/features/resources/domain/usecases/upload_resource.dart';
import 'package:eduflow/features/resources/presentation/bloc/resource_bloc.dart';

// ================= TASKS =================
import 'package:eduflow/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:eduflow/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:eduflow/features/tasks/data/models/task_model.dart';
import 'package:eduflow/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:eduflow/features/tasks/domain/repositories/task_repository.dart';
import 'package:eduflow/features/tasks/domain/usecases/create_task.dart';
import 'package:eduflow/features/tasks/domain/usecases/delete_task.dart';
import 'package:eduflow/features/tasks/domain/usecases/get_tasks_by_subject.dart';
import 'package:eduflow/features/tasks/domain/usecases/get_tasks_by_user.dart';
import 'package:eduflow/features/tasks/domain/usecases/update_task.dart';
import 'package:eduflow/features/tasks/presentation/bloc/task_bloc.dart';

// ================= PLANNER =================
import 'package:eduflow/features/planner/data/datasources/planner_local_datasource.dart';
import 'package:eduflow/features/planner/data/datasources/planner_remote_datasource.dart';
import 'package:eduflow/features/planner/data/models/study_session_model.dart';
import 'package:eduflow/features/planner/data/repositories/planner_repository_impl.dart';
import 'package:eduflow/features/planner/domain/repositories/planner_repository.dart';
import 'package:eduflow/features/planner/domain/usecases/create_session.dart';
import 'package:eduflow/features/planner/domain/usecases/update_session.dart';
import 'package:eduflow/features/planner/domain/usecases/delete_session.dart';
import 'package:eduflow/features/planner/domain/usecases/get_sessions_by_date.dart';
import 'package:eduflow/features/planner/domain/usecases/get_sessions_by_user.dart';
import 'package:eduflow/features/planner/presentation/bloc/planner_bloc.dart';

// ================= SUBJECTS =================
import 'package:eduflow/features/subjects/data/datasources/subject_local_datasource.dart';
import 'package:eduflow/features/subjects/data/datasources/subject_remote_datasource.dart';
import 'package:eduflow/features/subjects/data/models/subject_model.dart';
import 'package:eduflow/features/subjects/data/repositories/subject_repository_impl.dart';
import 'package:eduflow/features/subjects/domain/repositories/subject_repository.dart';
import 'package:eduflow/features/subjects/domain/usecases/create_subject.dart';
import 'package:eduflow/features/subjects/domain/usecases/delete_subject.dart';
import 'package:eduflow/features/subjects/domain/usecases/get_subjects.dart';
import 'package:eduflow/features/subjects/domain/usecases/update_subject.dart';
import 'package:eduflow/features/subjects/presentation/bloc/subject_bloc.dart';
import 'package:eduflow/features/user_management/data/datasources/user_local_datasource.dart';
import 'package:eduflow/features/user_management/data/datasources/user_remote_datasource.dart';
import 'package:eduflow/features/user_management/data/repositories/user_repository_impl.dart';
import 'package:eduflow/features/user_management/domain/repositories/user_repository.dart';
import 'package:eduflow/features/user_management/domain/usecases/get_current_user.dart';
import 'package:eduflow/features/user_management/domain/usecases/get_user.dart';
import 'package:eduflow/features/user_management/domain/usecases/login_user.dart';
import 'package:eduflow/features/user_management/domain/usecases/logout_user.dart';
import 'package:eduflow/features/user_management/domain/usecases/register_user.dart';
import 'package:eduflow/features/user_management/domain/usecases/reset_password.dart';
import 'package:eduflow/features/user_management/domain/usecases/update_user.dart';
import 'package:eduflow/features/user_management/domain/usecases/upload_user_avatar.dart';

import 'package:eduflow/features/user_management/presentation/bloc/user_bloc.dart';
import 'package:eduflow/features/user_management/presentation/cubit/reset_password_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  AppLogger.d('Setting up service locator...');

  // ========== LOCAL STORAGE ==========
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // ========== THEME ==========
  getIt.registerFactory(() => ThemeCubit(getIt()));

  // ========== FIREBASE ==========
  await Firebase.initializeApp();

  final firebaseAuth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  getIt.registerSingleton(firebaseAuth);
  getIt.registerSingleton(firestore);
  getIt.registerSingleton(storage);

  // ========== HIVE ==========
  await Hive.initFlutter();

  Hive.registerAdapter(SubjectModelAdapter());
  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(StudySessionModelAdapter());
  Hive.registerAdapter(FileResourceModelAdapter());
  Hive.registerAdapter(ReminderModelAdapter());
  Hive.registerAdapter(ProgressSnapshotModelAdapter());
  Hive.registerAdapter(ProgressTrendsModelAdapter());
  Hive.registerAdapter(AnalyticsInsightModelAdapter());
  Hive.registerAdapter(StudyGoalModelAdapter());

  final subjectsBox = await Hive.openBox<SubjectModel>('subjects');
  final tasksBox = await Hive.openBox<TaskModel>('tasks');

  getIt.registerSingleton(subjectsBox);
  getIt.registerSingleton(tasksBox);

  // ========== NETWORK ==========
  getIt.registerSingleton(Connectivity());
  getIt.registerSingleton<NetworkInfo>(NetworkInfoImpl(connectivity: getIt()));

  // HTTP client
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  // ========== USER FEATURE ==========

  final userLocal = UserLocalDatasourceImpl();
  await userLocal.init();

  getIt.registerSingleton<UserLocalDatasource>(userLocal);
  getIt.registerSingleton<UserRemoteDatasource>(
    UserRemoteDatasourceImpl(firebaseAuth, firestore, storage),
  );

  getIt.registerSingleton<UserRepository>(
    UserRepositoryImpl(local: getIt(), remote: getIt()),
  );

  getIt.registerSingleton(RegisterUserUseCase(getIt()));
  getIt.registerSingleton(LoginUserUseCase(getIt()));
  getIt.registerSingleton(GetUserUseCase(getIt()));
  getIt.registerSingleton(GetCurrentUserUseCase(getIt()));
  getIt.registerSingleton(LogoutUserUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateUserUseCase(getIt<UserRepository>()));
  getIt.registerLazySingleton(
    () => ResetPasswordUseCase(getIt<UserRepository>()),
  );
  getIt.registerLazySingleton(() => UploadUserAvatarUseCase(getIt()));

  getIt.registerFactory(
    () => ResetPasswordCubit(getIt<ResetPasswordUseCase>()),
  );

  // ✅ FIX: UserBloc must be FACTORY
  getIt.registerFactory<UserBloc>(
    () => UserBloc(
      registerUserUseCase: getIt(),
      loginUserUseCase: getIt(),
      getCurrentUserUseCase: getIt(),
      logoutUserUseCase: getIt(),
      updateUserUseCase: getIt(),
      uploadUserAvatarUseCase: getIt(),
    ),
  );

  // ========== ONBOARDING ==========
  getIt.registerFactory<OnboardingBloc>(
    () => OnboardingBloc(getIt<SharedPreferences>()),
  );

  // ================= ADMIN ANALYTICS =================

  // ---------------- ADMIN DATASOURCES ----------------

  getIt.registerLazySingleton<AdminAnalyticsRemoteDatasource>(
    () => AdminAnalyticsRemoteDatasourceImpl(getIt()),
  );

  getIt.registerLazySingleton<AdminRemoteDatasource>(
    () => AdminRemoteDatasourceImpl(getIt()),
  );

  getIt.registerLazySingleton<AdminLocalDatasource>(() {
    final ds = AdminLocalDatasourceImpl();
    ds.init(); // REQUIRED
    return ds;
  });

  // ---------------- ADMIN REPOSITORIES ----------------

  getIt.registerLazySingleton<AdminAnalyticsRepository>(
    () => AdminAnalyticsRepositoryImpl(remoteDatasource: getIt()),
  );

  getIt.registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(
      remoteDatasource: getIt<AdminRemoteDatasource>(),
      localDatasource: getIt<AdminLocalDatasource>(),
    ),
  );

  // Use cases

  getIt.registerLazySingleton(() => GetAllUsersUseCase(getIt()));

  getIt.registerLazySingleton(() => DeleteUserAdminUseCase(getIt()));

  getIt.registerLazySingleton(() => GetAllUserProgressUseCase(getIt()));

  getIt.registerLazySingleton(() => GetUserProgressUseCase(getIt()));

  getIt.registerLazySingleton(() => GetAdminStatsUseCase(getIt()));
  // Bloc
  getIt.registerFactory<AdminAnalyticsBloc>(
    () => AdminAnalyticsBloc(
      getAllUserProgressUseCase: getIt<GetAllUserProgressUseCase>(),
    ),
  );

  getIt.registerFactory<AdminUsersBloc>(
    () => AdminUsersBloc(
      getAllUsersUseCase: getIt<GetAllUsersUseCase>(),
      deleteUserAdminUseCase: getIt<DeleteUserAdminUseCase>(),
    ),
  );

  // Bloc (MUST BE FACTORY)
  getIt.registerFactory<AdminDashboardBloc>(
    () =>
        AdminDashboardBloc(getAdminStatsUseCase: getIt<GetAdminStatsUseCase>()),
  );

  // ========== SUBJECT FEATURE ==========

  getIt.registerSingleton<SubjectRemoteDatasource>(
    SubjectRemoteDatasourceImpl(firestore: firestore),
  );

  getIt.registerSingleton<SubjectLocalDatasource>(
    SubjectLocalDatasourceImpl(subjectsBox: subjectsBox),
  );

  getIt.registerSingleton<SubjectRepository>(
    SubjectRepositoryImpl(
      remoteDatasource: getIt(),
      localDatasource: getIt(),
      networkInfo: getIt(),
    ),
  );

  getIt.registerSingleton(GetSubjectsByUserUsecase(repository: getIt()));
  getIt.registerSingleton(CreateSubjectUsecase(repository: getIt()));
  getIt.registerSingleton(UpdateSubjectUsecase(repository: getIt()));
  getIt.registerSingleton(DeleteSubjectUsecase(repository: getIt()));

  getIt.registerFactory(
    () => SubjectBloc(
      getSubjectsByUser: getIt(),
      createSubject: getIt(),
      updateSubject: getIt(),
      deleteSubject: getIt(),
    ),
  );

  // ========== TASK FEATURE ==========

  getIt.registerSingleton<TaskRemoteDataSource>(
    TaskRemoteDataSourceImpl(firestore: firestore),
  );

  getIt.registerSingleton<TaskLocalDataSource>(TaskLocalDataSourceImpl());

  getIt.registerSingleton<TaskRepository>(
    TaskRepositoryImpl(
      remoteDatasource: getIt(),
      localDatasource: getIt(),
      networkInfo: getIt(),
    ),
  );

  getIt.registerSingleton(GetTasksBySubjectUsecase(repository: getIt()));
  getIt.registerSingleton(GetTasksByUserUsecase(repository: getIt()));
  getIt.registerSingleton(CreateTaskUsecase(repository: getIt()));
  getIt.registerSingleton(UpdateTaskUsecase(repository: getIt()));
  getIt.registerSingleton(DeleteTaskUsecase(repository: getIt()));

  getIt.registerFactory(
    () => TaskBloc(
      getTasksBySubjectUsecase: getIt(),
      getTasksByUserUsecase: getIt(),
      createTaskUsecase: getIt(),
      updateTaskUsecase: getIt(),
      deleteTaskUsecase: getIt(),
    ),
  );

  // ========== PLANNER FEATURE ==========
  getIt.registerSingleton<PlannerLocalDataSource>(PlannerLocalDataSourceImpl());

  getIt.registerSingleton<PlannerRemoteDataSource>(
    PlannerRemoteDataSourceImpl(firestore: firestore),
  );

  getIt.registerSingleton<PlannerRepository>(
    PlannerRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      connectivity: getIt(),
    ),
  );

  getIt.registerSingleton(CreateSession(getIt()));
  getIt.registerSingleton(UpdateSession(getIt()));
  getIt.registerSingleton(DeleteSession(getIt()));
  getIt.registerSingleton(GetSessionsByDate(getIt()));
  getIt.registerSingleton(GetSessionsByUser(getIt()));

  getIt.registerFactory(
    () => PlannerBloc(
      createSession: getIt(),
      updateSession: getIt(),
      deleteSession: getIt(),
      getSessionsByDate: getIt(),
      getSessionsByUser: getIt(),
    ),
  );

  // ========== Reminder FEATURE ==========

  // Data Sources
  getIt.registerSingleton<ReminderLocalDataSource>(
    ReminderLocalDataSourceImpl(),
  );
  getIt.registerSingleton<ReminderRemoteDataSource>(
    ReminderRemoteDataSourceImpl(firestore: getIt()),
  );

  // Repository
  getIt.registerSingleton<ReminderRepository>(
    ReminderRepositoryImpl(
      localDataSource: getIt<ReminderLocalDataSource>(),
      remoteDataSource: getIt<ReminderRemoteDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerSingleton<CreateReminderUseCase>(
    CreateReminderUseCase(getIt<ReminderRepository>()),
  );

  getIt.registerSingleton<DeleteReminderUseCase>(
    DeleteReminderUseCase(getIt<ReminderRepository>()),
  );
  getIt.registerSingleton<GetRemindersUseCase>(
    GetRemindersUseCase(getIt<ReminderRepository>()),
  );
  getIt.registerSingleton<GetSessionRemindersUseCase>(
    GetSessionRemindersUseCase(getIt<ReminderRepository>()),
  );
  getIt.registerSingleton<GetTaskRemindersUseCase>(
    GetTaskRemindersUseCase(getIt<ReminderRepository>()),
  );
  getIt.registerSingleton<MarkReminderTriggeredUseCase>(
    MarkReminderTriggeredUseCase(getIt<ReminderRepository>()),
  );
  getIt.registerSingleton<ToggleReminderUseCase>(
    ToggleReminderUseCase(getIt<ReminderRepository>()),
  );
  getIt.registerSingleton<UpdateReminderUseCase>(
    UpdateReminderUseCase(getIt<ReminderRepository>()),
  );

  // BLoC
  getIt.registerSingleton<ReminderBloc>(
    ReminderBloc(
      createReminder: getIt<CreateReminderUseCase>(),
      getReminders: getIt<GetRemindersUseCase>(),
      toggleReminder: getIt<ToggleReminderUseCase>(),
      deleteReminder: getIt<DeleteReminderUseCase>(),
      markTriggered: getIt<MarkReminderTriggeredUseCase>(),
    ),
  );

  // ========== ANALYTICS FEATURE ==========

  // Data Sources
  getIt.registerSingleton<AnalyticsLocalDataSource>(
    AnalyticsLocalDataSourceImpl(),
  );

  getIt.registerSingleton<AnalyticsRemoteDataSource>(
    AnalyticsRemoteDataSourceImpl(getIt()),
  );

  // Repository
  getIt.registerSingleton<AnalyticsRepository>(
    AnalyticsRepositoryImpl(
      localDataSource: getIt(),
      remoteDataSource: getIt(),
      taskRepository: getIt<TaskRepository>(),
      plannerRepository: getIt<PlannerRepository>(),
    ),
  );

  // Use Cases
  getIt.registerSingleton<CreateStudyGoalUseCase>(
    CreateStudyGoalUseCase(getIt<AnalyticsRepository>()),
  );

  getIt.registerSingleton<DeleteStudyGoalUseCase>(
    DeleteStudyGoalUseCase(getIt<AnalyticsRepository>()),
  );

  getIt.registerSingleton<GetActiveGoalsUseCase>(
    GetActiveGoalsUseCase(getIt<AnalyticsRepository>()),
  );

  getIt.registerSingleton<LoadAnalyticsOverviewUseCase>(
    LoadAnalyticsOverviewUseCase(getIt<AnalyticsRepository>()),
  );

  getIt.registerSingleton<UpdateStudyGoalUseCase>(
    UpdateStudyGoalUseCase(getIt<AnalyticsRepository>()),
  );

  // Bloc  ✅ MUST BE FACTORY
  getIt.registerFactory<AnalyticsBloc>(
    () => AnalyticsBloc(
      loadOverview: getIt(),
      createGoal: getIt(),
      updateGoal: getIt(),
      deleteGoal: getIt(),
    ),
  );

  // ========== Resource Feature ==========

  // Data Sources
  getIt.registerSingleton<ResourceLocalDataSource>(
    ResourceLocalDataSourceImpl(),
  );

  getIt.registerSingleton<ResourceRemoteDataSource>(
    ResourceRemoteDataSourceImpl(firestore: getIt()),
  );

  getIt.registerSingleton<ResourceStorageDataSource>(
    ResourceStorageDataSourceImpl(getIt()),
  );

  // Repository
  getIt.registerSingleton<ResourceRepository>(
    ResourceRepositoryImpl(remote: getIt(), local: getIt(), storage: getIt()),
  );

  // Use Cases
  getIt.registerSingleton<RestoreResourceUsecase>(
    RestoreResourceUsecase(getIt<ResourceRepository>()),
  );

  getIt.registerSingleton<SoftDeleteResourceUsecase>(
    SoftDeleteResourceUsecase(getIt<ResourceRepository>()),
  );

  getIt.registerSingleton<GetResourcesBySubjectUsecase>(
    GetResourcesBySubjectUsecase(repository: getIt<ResourceRepository>()),
  );

  getIt.registerSingleton<GetResourcesByUserUsecase>(
    GetResourcesByUserUsecase(repository: getIt<ResourceRepository>()),
  );

  getIt.registerSingleton<ToggleFavoriteResourceUsecase>(
    ToggleFavoriteResourceUsecase(repository: getIt<ResourceRepository>()),
  );

  getIt.registerSingleton<UploadResourceUsecase>(
    UploadResourceUsecase(getIt<ResourceRepository>()),
  );

  // Bloc  ✅ MUST BE FACTORY
  getIt.registerFactory<ResourceBloc>(
    () => ResourceBloc(
      getByUser: getIt(),
      getBySubject: getIt(),
      upload: getIt(),
      softDelete: getIt(),
      restore: getIt(),
      toggleFavorite: getIt(),
    ),
  );

  AppLogger.d('Service locator setup complete');
}
