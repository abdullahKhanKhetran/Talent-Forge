part of 'employee_bloc.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object> get props => [];
}

class LoadEmployees extends EmployeeEvent {
  final bool isSilent;
  const LoadEmployees({this.isSilent = false});

  @override
  List<Object> get props => [isSilent];
}

class LoadDepartments extends EmployeeEvent {
  final bool isSilent;
  const LoadDepartments({this.isSilent = false});

  @override
  List<Object> get props => [isSilent];
}

class AddEmployee extends EmployeeEvent {
  final Map<String, dynamic> employeeData;

  const AddEmployee(this.employeeData);

  @override
  List<Object> get props => [employeeData];
}

class UpdateEmployee extends EmployeeEvent {
  final String id;
  final Map<String, dynamic> employeeData;

  const UpdateEmployee({required this.id, required this.employeeData});

  @override
  List<Object> get props => [id, employeeData];
}

class DeleteEmployee extends EmployeeEvent {
  final String id;

  const DeleteEmployee(this.id);

  @override
  List<Object> get props => [id];
}
