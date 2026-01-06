import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../shared/widgets/loading_indicator.dart';
import '../../../../../shared/widgets/error_widget.dart';
import '../../../../../shared/widgets/risk_score_badge.dart';
import '../bloc/attendance_dashboard_bloc.dart';

class AttendanceDashboardPage extends StatefulWidget {
  const AttendanceDashboardPage({super.key});

  @override
  State<AttendanceDashboardPage> createState() =>
      _AttendanceDashboardPageState();
}

class _AttendanceDashboardPageState extends State<AttendanceDashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<AttendanceDashboardBloc>().add(LoadLiveAttendance());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Attendance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<AttendanceDashboardBloc>().add(LoadLiveAttendance());
            },
          ),
        ],
      ),
      body: BlocBuilder<AttendanceDashboardBloc, AttendanceDashboardState>(
        builder: (context, state) {
          if (state is AttendanceDashboardLoading) {
            return const LoadingIndicator(message: 'Loading live data...');
          } else if (state is AttendanceDashboardFailure) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<AttendanceDashboardBloc>().add(
                LoadLiveAttendance(),
              ),
            );
          } else if (state is AttendanceDashboardLoaded) {
            final records = state.records;
            final presentCount = records
                .where((r) => r.status == 'present')
                .length;
            final absentCount = records
                .where((r) => r.status == 'absent')
                .length;
            final lateCount = records.where((r) => r.status == 'late').length;

            return CustomScrollView(
              slivers: [
                // Stats Grid
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        _buildStatCard(
                          'Present',
                          presentCount,
                          AppColors.success,
                        ),
                        const SizedBox(width: 8),
                        _buildStatCard('Absent', absentCount, AppColors.error),
                        const SizedBox(width: 8),
                        _buildStatCard('Late', lateCount, AppColors.warning),
                      ],
                    ),
                  ),
                ),

                // Pie Chart
                SliverToBoxAdapter(
                  child: Container(
                    height: 200,
                    padding: const EdgeInsets.all(16),
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: presentCount.toDouble(),
                            color: AppColors.success,
                            title: 'Present',
                            radius: 50,
                          ),
                          PieChartSectionData(
                            value: absentCount.toDouble(),
                            color: AppColors.error,
                            title: 'Absent',
                            radius: 50,
                          ),
                          PieChartSectionData(
                            value: lateCount.toDouble(),
                            color: AppColors.warning,
                            title: 'Late',
                            radius: 50,
                          ),
                        ],
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),
                ),

                // Live List
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final record = records[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey.shade200,
                            child: Text(
                              '${record.userId}',
                            ), // Placeholder for initial
                          ),
                          title: Text(
                            'User #${record.userId}',
                          ), // Placeholder for name
                          subtitle: Text(
                            'In: ${record.checkIn ?? '-'} | Out: ${record.checkOut ?? '-'}',
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                record.status.toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              if (record.riskScore != null)
                                RiskScoreBadge(
                                  score: record.riskScore!,
                                  showLabel: false,
                                ),
                            ],
                          ),
                        ),
                      );
                    }, childCount: records.length),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildStatCard(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
