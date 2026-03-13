import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduflow/core/widgets/app_shimmer.dart';
import '../../../subjects/presentation/bloc/subject_bloc.dart';
import '../../../subjects/presentation/bloc/subject_event.dart';

import '../bloc/analytics_bloc.dart';
import '../bloc/analytics_event.dart';
import '../bloc/analytics_state.dart';
import '../widgets/weekly_activity_chart.dart';

class AnalyticsDashboardPage extends StatefulWidget {
  final String userId;

  const AnalyticsDashboardPage({super.key, required this.userId});

  @override
  State<AnalyticsDashboardPage> createState() => _AnalyticsDashboardPageState();
}

class _AnalyticsDashboardPageState extends State<AnalyticsDashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<AnalyticsBloc>().add(
      LoadAnalyticsEvent(userId: widget.userId),
    );
    // Ensure subjects are loaded for mapping names/colors
    context.read<SubjectBloc>().add(LoadSubjectsEvent(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: const Text('Track Progress'), centerTitle: true),
      body: SafeArea(
        child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
          builder: (context, state) {
            if (state.status == AnalyticsStatus.loading &&
                state.overview == null) {
              return _buildLoadingShim();
            }

            if (state.status == AnalyticsStatus.failure &&
                state.overview == null) {
              return Center(
                child: Text(
                  state.errorMessage ?? 'Error loading analytics',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (state.overview != null) {
              final overview = state.overview!;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    WeeklyActivityChart(
                      studyHours: overview.trends.dailyStudyHours,
                      taskCompletion: overview.trends.dailyTaskCompletion,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingShim() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: const [
          AppShimmer(width: double.infinity, height: 300, borderRadius: 24),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
