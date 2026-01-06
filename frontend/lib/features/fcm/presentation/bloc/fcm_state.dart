part of 'fcm_bloc.dart';

sealed class FcmState extends Equatable {
  const FcmState();

  @override
  List<Object> get props => [];
}

final class FcmInitial extends FcmState {}

final class FcmFailure extends FcmState {
  final String message;
  const FcmFailure({required this.message});
}

final class FcmSuccess extends FcmState {
  final Device device;
  const FcmSuccess({required this.device});
}
