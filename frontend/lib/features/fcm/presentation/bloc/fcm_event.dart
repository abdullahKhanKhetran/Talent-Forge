part of 'fcm_bloc.dart';

sealed class FcmEvent extends Equatable {
  const FcmEvent();

  @override
  List<Object> get props => [];
}

class UpsertFcmDeviceEvent extends FcmEvent {
  final String userId;
  final String? authStatus;
  const UpsertFcmDeviceEvent({required this.userId, this.authStatus});
}
