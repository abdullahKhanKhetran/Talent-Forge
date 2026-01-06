import 'package:equatable/equatable.dart';

class LeaveType extends Equatable {
  final int id;
  final String name;
  final String code;
  final bool isPaid;

  const LeaveType({
    required this.id,
    required this.name,
    required this.code,
    required this.isPaid,
  });

  @override
  List<Object?> get props => [id, name, code, isPaid];
}
