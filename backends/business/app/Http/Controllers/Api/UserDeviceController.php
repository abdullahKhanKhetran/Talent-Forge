<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\UserDevice; // Create this model if not exists
use Illuminate\Support\Facades\Auth;

class UserDeviceController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'fcm_token' => 'required|string',
            'device_info' => 'nullable|array',
            'platform' => 'required|string',
            'id' => 'required|string', // Device ID from frontend
        ]);

        $user = Auth::user();

        // Upsert device info
        // We use the device 'id' (uuid) as unique key for the device
        
        // Note: Check if UserDevice model exists, if not we will create it.
        // Assuming table 'user_devices' exists.

        $device = UserDevice::updateOrCreate(
            ['device_id' => $request->id],
            [
                'user_id' => $user->id,
                'fcm_token' => $request->fcm_token,
                'platform' => $request->platform,
                'last_active' => now(),
                'meta_data' => $request->device_info
            ]
        );

        return response()->json([
            'status' => 'success',
            'data' => $device,
            'message' => 'Device info synced.'
        ]);
    }
}
