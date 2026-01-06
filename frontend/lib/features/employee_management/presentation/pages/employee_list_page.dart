import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/entities/user.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/employee_bloc.dart';

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({super.key});

  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  @override
  void initState() {
    super.initState();
    context.read<EmployeeBloc>().add(LoadEmployees());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employees'), centerTitle: true),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.goNamed('add-employee');
        },
        label: const Text('Add Employee'),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.primary,
        elevation: 4,
      ),
      body: BlocConsumer<EmployeeBloc, EmployeeState>(
        listener: (context, state) {
          if (state is EmployeeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is EmployeeOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            context.read<EmployeeBloc>().add(LoadEmployees());
          }
        },
        buildWhen: (previous, current) =>
            current is EmployeeLoaded || current is EmployeeLoading,
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmployeeLoaded) {
            if (state.employees.isEmpty) {
              return const Center(child: Text("No employees found."));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.employees.length,
              itemBuilder: (context, index) {
                final employee = state.employees[index];
                return _EmployeeCard(employee: employee);
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  final User employee;

  const _EmployeeCard({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Text(
            employee.name.isNotEmpty ? employee.name[0].toUpperCase() : 'E',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          employee.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(employee.designation ?? 'No designation'),
            Text(
              employee.email,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: () {
          context.goNamed('edit-employee', extra: employee);
        },
      ),
    );
  }
}
