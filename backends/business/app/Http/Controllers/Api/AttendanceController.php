<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\AttendanceLog;
use Illuminate\Support\Facades\Auth;
use Carbon\Carbon;

class AttendanceController extends Controller
{
    /**
     * Check In
     */
    public function checkIn(Request $request)
    {
        $request->validate([
            'latitude' => 'required|numeric',
            'longitude' => 'required|numeric',
            'notes' => 'nullable|string',
        ]);

        $user = Auth::user();

        // Check if already checked in today
        $existing = AttendanceLog::where('user_id', $user->id)
            ->whereDate('date', Carbon::today())
            ->first();

        if ($existing) {
            return response()->json([
                'status' => 'error',
                'message' => 'Already checked in today.',
            ], 400);
        }

        $attendance = AttendanceLog::create([
            'user_id' => $user->id,
            'date' => Carbon::today(),
            'check_in_time' => Carbon::now(),
            'status' => 'present',
            'location_data' => json_encode([
                'check_in' => [
                    'lat' => $request->latitude,
                    'long' => $request->longitude,
                    'notes' => $request->notes
                ]
            ]),
        ]);

        return response()->json([
            'status' => 'success',
            'data' => $attendance,
            'message' => 'Checked in successfully.'
        ]);
    }

    /**
     * Check Out
     */
    public function checkOut(Request $request)
    {
        $request->validate([
            'latitude' => 'required|numeric',
            'longitude' => 'required|numeric',
        ]);

        $user = Auth::user();

        $attendance = AttendanceLog::where('user_id', $user->id)
            ->whereDate('date', Carbon::today())
            ->first();

        if (!$attendance) {
            return response()->json([
                'status' => 'error',
                'message' => 'No check-in record found for today.',
            ], 404);
        }

        if ($attendance->check_out_time) {
            return response()->json([
                'status' => 'error',
                'message' => 'Already checked out.',
            ], 400);
        }

        $attendance->check_out_time = Carbon::now();
        
        // Update location data
        $locationData = json_decode($attendance->location_data, true) ?? [];
        $locationData['check_out'] = [
            'lat' => $request->latitude,
            'long' => $request->longitude
        ];
        $attendance->location_data = json_encode($locationData);
        
        // Calculate duration (hours)
        $duration = Carbon::parse($attendance->check_in_time)->diffInHours(Carbon::now());
        $attendance->working_hours = $duration;

        $attendance->save();

        return response()->json([
            'status' => 'success',
            'data' => $attendance,
            'message' => 'Checked out successfully.'
        ]);
    }

    /**
     * Get History
     */
    public function history(Request $request)
    {
        $user = Auth::user();
        $history = AttendanceLog::where('user_id', $user->id)
            ->orderBy('date', 'desc')
            ->paginate(10);

        return response()->json([
            'status' => 'success',
            'data' => $history->items(), // Flutter expects list in 'data'
            'meta' => [
                'current_page' => $history->currentPage(),
                'last_page' => $history->lastPage(),
            ]
        ]);
    }

    /**
     * Live Attendance (Admin)
     */
    public function live(Request $request)
    {
        // In a real app, ensure admin middleware
        $today = AttendanceLog::with('user')
            ->whereDate('date', Carbon::today())
            ->get();

        return response()->json([
            'status' => 'success',
            'data' => $today
        ]);
    }
}
