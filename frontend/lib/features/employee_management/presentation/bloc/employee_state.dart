part of 'employee_bloc.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object> get props => [];
}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final List<User> employees;

  const EmployeeLoaded(this.employees);

  @override
  List<Object> get props => [employees];
}

class DepartmentsLoaded extends EmployeeState {
  final List<dynamic> departments;

  const DepartmentsLoaded(this.departments);

  @override
  List<Object> get props => [departments];
}

class EmployeeOperationSuccess extends EmployeeState {
  final String message;

  const EmployeeOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class EmployeeError extends EmployeeState {
  final String message;

  const EmployeeError(this.message);

  @override
  List<Object> get props => [message];
}
