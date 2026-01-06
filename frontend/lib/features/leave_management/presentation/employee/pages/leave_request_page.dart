import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../shared/widgets/custom_button.dart';
import '../../../../../shared/widgets/custom_text_field.dart';
import '../../../../../shared/widgets/loading_indicator.dart';
import '../../../../../shared/utils/date_formatter.dart';
import '../../../domain/entities/leave_type.dart';
import '../bloc/leave_request_bloc.dart';

class LeaveRequestPage extends StatefulWidget {
  const LeaveRequestPage({super.key});

  @override
  State<LeaveRequestPage> createState() => _LeaveRequestPageState();
}

class _LeaveRequestPageState extends State<LeaveRequestPage> {
  final _reasonController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  LeaveType? _selectedLeaveType;

  @override
  void initState() {
    super.initState();
    context.read<LeaveRequestBloc>().add(LoadLeaveDashboard());
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _submit() {
    if (_selectedLeaveType == null ||
        _startDate == null ||
        _endDate == null ||
        _reasonController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    if (_endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End date cannot be before start date')),
      );
      return;
    }

    context.read<LeaveRequestBloc>().add(
      SubmitLeaveRequest(
        leaveTypeId: _selectedLeaveType!.id,
        startDate: _startDate!,
        endDate: _endDate!,
        reason: _reasonController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leave Management')),
      body: BlocConsumer<LeaveRequestBloc, LeaveRequestState>(
        listener: (context, state) {
          if (state is LeaveRequestSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
            _reasonController.clear();
            setState(() {
              _startDate = null;
              _endDate = null;
              _selectedLeaveType = null;
            });
          } else if (state is LeaveRequestFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is LeaveRequestLoading && state is! LeaveDashboardLoaded) {
            return const LoadingIndicator();
          }

          if (state is LeaveDashboardLoaded ||
              (state is LeaveRequestLoading && _selectedLeaveType != null)) {
            // If loading but we have data (optimistic UI or re-loading), show content
            final loadedState = state is LeaveDashboardLoaded
                ? state
                : (context.read<LeaveRequestBloc>().state
                      as LeaveDashboardLoaded);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Balances Section
                  const Text(
                    'My Balances',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: loadedState.balances.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final balance = loadedState.balances[index];
                        return Container(
                          width: 140,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.shade100),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                balance.leaveType.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${balance.remainingDays} days left',
                                style: TextStyle(color: Colors.blue.shade800),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Request Form
                  const Text(
                    'New Request',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<LeaveType>(
                    value: _selectedLeaveType,
                    decoration: const InputDecoration(
                      labelText: 'Leave Type',
                      border: OutlineInputBorder(),
                    ),
                    items: loadedState.leaveTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.name),
                      );
                    }).toList(),
                    onChanged: (val) =>
                        setState(() => _selectedLeaveType = val),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(context, true),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Start Date',
                              border: OutlineInputBorder(),
                            ),
                            child: Text(
                              _startDate != null
                                  ? DateFormat('yyyy-MM-dd').format(_startDate!)
                                  : 'Select',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(context, false),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'End Date',
                              border: OutlineInputBorder(),
                            ),
                            child: Text(
                              _endDate != null
                                  ? DateFormat('yyyy-MM-dd').format(_endDate!)
                                  : 'Select',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    controller: _reasonController,
                    labelText: 'Reason',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  CustomButton(
                    text: 'SUBMIT REQUEST',
                    onPressed: state is LeaveRequestLoading ? null : _submit,
                  ),

                  const SizedBox(height: 32),

                  // History
                  const Text(
                    'Request History',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...loadedState.requestHistory.map(
                    (req) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(
                          '${req.leaveType.name} (${req.totalDays} days)',
                        ),
                        subtitle: Text(
                          '${DateFormatter.formatDate(DateTime.parse(req.startDate))} - ${DateFormatter.formatDate(DateTime.parse(req.endDate))}',
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(req.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _getStatusColor(req.status),
                            ),
                          ),
                          child: Text(
                            req.status.toUpperCase(),
                            style: TextStyle(
                              color: _getStatusColor(req.status),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Something went wrong.'));
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return AppColors.success;
      case 'rejected':
        return AppColors.error;
      default:
        return Colors.orange;
    }
  }
}
