import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/device.dart';
import '../../domain/usecases/upsert_device.dart';

part 'fcm_event.dart';
part 'fcm_state.dart';

class FcmBloc extends Bloc<FcmEvent, FcmState> {
  final UpsertDevice upsertDevice;

  FcmBloc({required this.upsertDevice}) : super(FcmInitial()) {
    on<UpsertFcmDeviceEvent>(_onUpsertFcmDevice);
  }

  Future<void> _onUpsertFcmDevice(
    UpsertFcmDeviceEvent event,
    Emitter<FcmState> emit,
  ) async {
    // We could emit loading here if we wanted
    // emit(FcmLoading());

    final res = await upsertDevice(
      UpsertDeviceParams(userId: event.userId, authStatus: event.authStatus),
    );

    res.fold(
      (failure) => emit(FcmFailure(message: failure.message)),
      (device) => emit(FcmSuccess(device: device)),
    );
  }
}
