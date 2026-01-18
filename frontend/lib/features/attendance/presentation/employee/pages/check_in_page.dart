import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../shared/widgets/custom_button.dart';
import '../../../../../shared/widgets/custom_text_field.dart';
import '../../../../../shared/widgets/loading_indicator.dart';
import '../../../../../shared/utils/date_formatter.dart';
import '../../../../../shared/utils/permission_handler.dart';
import '../bloc/check_in_bloc.dart';

class CheckInPage extends StatefulWidget {
  const CheckInPage({super.key});

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  final _notesController = TextEditingController();
  bool _isLoadingLocation = false;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    context.read<CheckInBloc>().add(GetTodayAttendance());
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    var status = await Permission.location.status;
    if (status.isPermanentlyDenied) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Permission Required'),
            content: const Text(
              'Location permission is permanently denied. Please enable it in settings to use attendance features.',
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  PermissionHelper.openSettings();
                  context.pop();
                },
                child: const Text('OPEN SETTINGS'),
              ),
            ],
          ),
        );
        setState(() => _isLoadingLocation = false);
      }
      return;
    }

    final hasPermission = await PermissionHelper.requestLocationPermission();
    if (!hasPermission) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permission is required for attendance'),
          ),
        );
        setState(() => _isLoadingLocation = false);
      }
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingLocation = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error getting location: $e')));
      }
    }
  }

  Future<void> _onCheckIn() async {
    if (_currentPosition == null) {
      await _getCurrentLocation();
      if (_currentPosition == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to determine location. Please try again.'),
            ),
          );
        }
        return;
      }
    }

    if (mounted) {
      context.read<CheckInBloc>().add(
        CheckIn(
          latitude: _currentPosition!.latitude,
          longitude: _currentPosition!.longitude,
          notes: _notesController.text,
        ),
      );
    }
  }

  Future<void> _onCheckOut() async {
    if (_currentPosition == null) {
      await _getCurrentLocation();
      if (_currentPosition == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to determine location. Please try again.'),
            ),
          );
        }
        return;
      }
    }

    if (mounted) {
      context.read<CheckInBloc>().add(
        CheckOut(
          latitude: _currentPosition!.latitude,
          longitude: _currentPosition!.longitude,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Check-In'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _getCurrentLocation();
              context.read<CheckInBloc>().add(GetTodayAttendance());
            },
          ),
        ],
      ),
      body: BlocConsumer<CheckInBloc, CheckInState>(
        listener: (context, state) {
          if (state is CheckInSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
            _notesController.clear();
            context.read<CheckInBloc>().add(GetTodayAttendance());
          } else if (state is CheckInFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Location Status Card
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 48,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isLoadingLocation
                              ? 'Getting location...'
                              : _currentPosition != null
                              ? 'Location Acquired'
                              : 'Location Required',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (_currentPosition != null)
                          Text(
                            'Lat: ${_currentPosition!.latitude.toStringAsFixed(4)}, Long: ${_currentPosition!.longitude.toStringAsFixed(4)}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Map Placeholder
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.map, size: 32, color: Colors.grey),
                        const SizedBox(height: 8),
                        Text(
                          'Map Preview',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Activity Controls
                CustomTextField(
                  controller: _notesController,
                  labelText: 'Notes (Optional)',
                  hintText: 'Working from home, Client meeting, etc.',
                  maxLines: 2,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'CHECK IN',
                        onPressed:
                            (_currentPosition != null &&
                                state is! CheckInLoading)
                            ? _onCheckIn
                            : null,
                        icon: Icons.login,
                        backgroundColor: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomButton(
                        text: 'CHECK OUT',
                        onPressed:
                            (_currentPosition != null &&
                                state is! CheckInLoading)
                            ? _onCheckOut
                            : null,
                        icon: Icons.logout,
                        backgroundColor: AppColors.error,
                      ),
                    ),
                  ],
                ),

                if (state is CheckInLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: LoadingIndicator(),
                  ),

                const SizedBox(height: 32),

                // Recent Activity
                const Text(
                  'Today\'s Activity',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (state is TodayAttendanceLoaded) ...[
                  if (state.records.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No activity recorded today.'),
                    )
                  else
                    ...state.records.map(
                      (record) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Icon(
                            record.checkOut != null
                                ? Icons.check_circle
                                : Icons.schedule,
                            color: record.checkOut != null
                                ? AppColors.success
                                : Colors.orange,
                          ),
                          title: Text(
                            DateFormatter.formatDate(
                              DateTime.tryParse(record.date) ?? DateTime.now(),
                            ),
                          ),
                          subtitle: Text(
                            'In: ${record.checkIn ?? '-'} | Out: ${record.checkOut ?? '-'}',
                          ),
                          trailing: Text(
                            record.status.toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
