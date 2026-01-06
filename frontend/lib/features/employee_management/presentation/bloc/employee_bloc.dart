import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/common/entities/user.dart';
import '../../domain/repositories/employee_repository.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeRepository _employeeRepository;

  EmployeeBloc({required EmployeeRepository employeeRepository})
    : _employeeRepository = employeeRepository,
      super(EmployeeInitial()) {
    on<LoadEmployees>(_onLoadEmployees);
    on<LoadDepartments>(_onLoadDepartments);
    on<AddEmployee>(_onAddEmployee);
    on<UpdateEmployee>(_onUpdateEmployee);
    on<DeleteEmployee>(_onDeleteEmployee);
  }

  Future<void> _onLoadEmployees(
    LoadEmployees event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading());
    final result = await _employeeRepository.getEmployees();
    result.fold(
      (failure) => emit(EmployeeError(failure.message)),
      (employees) => emit(EmployeeLoaded(employees)),
    );
  }

  Future<void> _onLoadDepartments(
    LoadDepartments event,
    Emitter<EmployeeState> emit,
  ) async {
    // We don't want to show full loading screen for dropdown
    // But if we reuse EmployeeLoading it might trigger full screen loader
    // For simplicity, let's just emit loaded state or we can use a separate loading state
    final result = await _employeeRepository.getDepartments();
    result.fold(
      (failure) => emit(EmployeeError(failure.message)),
      (departments) => emit(DepartmentsLoaded(departments)),
    );
  }

  Future<void> _onAddEmployee(
    AddEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading());
    final result = await _employeeRepository.addEmployee(event.employeeData);
    result.fold(
      (failure) => emit(EmployeeError(failure.message)),
      (_) =>
          emit(const EmployeeOperationSuccess('Employee added successfully')),
    );
  }

  Future<void> _onUpdateEmployee(
    UpdateEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading());
    final result = await _employeeRepository.updateEmployee(
      event.id,
      event.employeeData,
    );
    result.fold(
      (failure) => emit(EmployeeError(failure.message)),
      (_) =>
          emit(const EmployeeOperationSuccess('Employee updated successfully')),
    );
  }

  Future<void> _onDeleteEmployee(
    DeleteEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading());
    final result = await _employeeRepository.deleteEmployee(event.id);
    result.fold(
      (failure) => emit(EmployeeError(failure.message)),
      (_) =>
          emit(const EmployeeOperationSuccess('Employee deleted successfully')),
    );
  }
}
