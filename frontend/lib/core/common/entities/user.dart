import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String role; // 'admin', 'hr', 'employee', 'manager'
  final String? designation;
  final String? departmentId;
  final String? employeeCode;
  final String? phone;
  final String? status;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.designation,
    this.departmentId,
    this.employeeCode,
    this.phone,
    this.status,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    role,
    designation,
    departmentId,
    employeeCode,
    phone,
    status,
  ];
}
