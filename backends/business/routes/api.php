<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Routes registered here are prefixed with /api.
| These routes are called by the .NET Gateway (IngestorService).
|
*/

// Public Auth Routes
Route::prefix('auth')->group(function () {
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login', [AuthController::class, 'login']);
});

// Protected Routes (Require Passport Token)
Route::middleware('auth:api')->group(function () {
    // Auth
    Route::post('/auth/logout', [AuthController::class, 'logout']);
    Route::get('/auth/me', [AuthController::class, 'me']);

    // --- Employee Management (Admin Only) ---
    Route::apiResource('employees', App\Http\Controllers\Api\EmployeeController::class);
    Route::apiResource('departments', App\Http\Controllers\Api\DepartmentController::class);

    // --- Attendance ---
    Route::post('/attendance/check-in', [App\Http\Controllers\Api\AttendanceController::class, 'checkIn']);
    Route::post('/attendance/check-out', [App\Http\Controllers\Api\AttendanceController::class, 'checkOut']);
    Route::get('/attendance/history', [App\Http\Controllers\Api\AttendanceController::class, 'history']);
    Route::get('/attendance/live', [App\Http\Controllers\Api\AttendanceController::class, 'live']);

    // --- Leave Management ---
    Route::post('/leaves', [App\Http\Controllers\Api\LeaveController::class, 'store']);
    Route::get('/leaves/my-requests', [App\Http\Controllers\Api\LeaveController::class, 'myRequests']);
    Route::get('/leave-balances', [App\Http\Controllers\Api\LeaveController::class, 'balances']);
    Route::get('/leave-types', [App\Http\Controllers\Api\LeaveController::class, 'types']);
    
    // Admin Leave Routes
    Route::get('/admin/leaves/pending', [App\Http\Controllers\Api\LeaveController::class, 'pending']);
    Route::post('/admin/leaves/{id}/approve', [App\Http\Controllers\Api\LeaveController::class, 'approve']);
    Route::post('/admin/leaves/{id}/reject', [App\Http\Controllers\Api\LeaveController::class, 'reject']);

    // --- FCM / Devices ---
    Route::post('/user-devices', [App\Http\Controllers\Api\UserDeviceController::class, 'store']);
});
