import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/entities/user.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../bloc/employee_bloc.dart';

class AddEditEmployeePage extends StatefulWidget {
  final User? employee;

  const AddEditEmployeePage({super.key, this.employee});

  @override
  State<AddEditEmployeePage> createState() => _AddEditEmployeePageState();
}

class _AddEditEmployeePageState extends State<AddEditEmployeePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _designationController;
  late TextEditingController _employeeCodeController;
  late TextEditingController _phoneController;

  String? _selectedDepartmentId;
  String _status = 'active';

  @override
  void initState() {
    super.initState();
    final e = widget.employee;
    _nameController = TextEditingController(text: e?.name);
    _emailController = TextEditingController(text: e?.email);
    _passwordController = TextEditingController(); // Only for new employees
    _designationController = TextEditingController(text: e?.designation);
    _employeeCodeController = TextEditingController(text: e?.employeeCode);
    _phoneController = TextEditingController(text: e?.phone);
    _selectedDepartmentId = e?.departmentId;
    _status = e?.status ?? 'active';

    context.read<EmployeeBloc>().add(LoadDepartments());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _designationController.dispose();
    _employeeCodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final data = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        if (widget.employee == null)
          'password': _passwordController.text, // Only send password for new
        'designation': _designationController.text.trim(),
        'department_id': _selectedDepartmentId,
        'employee_code': _employeeCodeController.text.trim(),
        'phone': _phoneController.text.trim(),
        'status': _status,
      };

      if (widget.employee == null) {
        context.read<EmployeeBloc>().add(AddEmployee(data));
      } else {
        context.read<EmployeeBloc>().add(
          UpdateEmployee(
            id: widget.employee!.id.toString(),
            employeeData: data,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.employee != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Employee' : 'Add Employee')),
      body: BlocConsumer<EmployeeBloc, EmployeeState>(
        listener: (context, state) {
          if (state is EmployeeOperationSuccess) {
            context.pop(); // Go back to list
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is EmployeeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          List<dynamic> departments = [];
          if (state is DepartmentsLoaded) {
            departments = state.departments;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextField(
                    controller: _nameController,
                    labelText: 'Full Name',
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  if (!isEdit) ...[
                    CustomTextField(
                      controller: _passwordController,
                      labelText: 'Password',
                      obscureText: true,
                      validator: (v) => v!.length < 8 ? 'Min 8 chars' : null,
                    ),
                    const SizedBox(height: 16),
                  ],
                  CustomTextField(
                    controller: _designationController,
                    labelText: 'Designation',
                  ),
                  const SizedBox(height: 16),
                  // Department Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedDepartmentId,
                    decoration: const InputDecoration(
                      labelText: 'Department',
                      border: OutlineInputBorder(),
                    ),
                    items: departments.map<DropdownMenuItem<String>>((dept) {
                      return DropdownMenuItem(
                        value: dept['id'].toString(),
                        child: Text(dept['name']),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedDepartmentId = val;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _employeeCodeController,
                    labelText: 'Employee Code',
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _phoneController,
                    labelText: 'Phone',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Save',
                    isLoading: state is EmployeeLoading,
                    onPressed: _onSave,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
