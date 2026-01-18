<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\LeaveRequest;
use App\Models\LeaveBalance;
use App\Models\LeaveType;
use Illuminate\Support\Facades\Auth;

class LeaveController extends Controller
{
    /**
     * Submit Leave Request
     */
    public function store(Request $request)
    {
        $request->validate([
            'leave_type_id' => 'required|exists:leave_types,id',
            'start_date' => 'required|date',
            'end_date' => 'required|date|after_or_equal:start_date',
            'reason' => 'required|string',
        ]);

        $user = Auth::user();

        // Calculate days requested
        $start = \Carbon\Carbon::parse($request->start_date);
        $end = \Carbon\Carbon::parse($request->end_date);
        $daysRequested = $start->diffInDays($end) + 1;

        $leave = LeaveRequest::create([
            'user_id' => $user->id,
            'leave_type_id' => $request->leave_type_id,
            'start_date' => $request->start_date,
            'end_date' => $request->end_date,
            'days_requested' => $daysRequested,
            'reason' => $request->reason,
            'status' => 'pending',
        ]);

        return response()->json([
            'status' => 'success',
            'data' => $leave,
            'message' => 'Leave request submitted.'
        ]);
    }

    /**
     * Get My Requests
     */
    public function myRequests()
    {
        $user = Auth::user();
        $requests = LeaveRequest::with('leaveType')
            ->where('user_id', $user->id)
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'status' => 'success',
            'data' => $requests
        ]);
    }

    /**
     * Get Balances
     */
    public function balances()
    {
        $user = Auth::user();
        $balances = LeaveBalance::with('leaveType')
            ->where('user_id', $user->id)
            ->get();

        return response()->json([
            'status' => 'success',
            'data' => $balances
        ]);
    }

    /**
     * Get Types
     */
    public function types()
    {
        $types = LeaveType::all();
        return response()->json([
            'status' => 'success',
            'data' => $types
        ]);
    }

    /**
     * Admin: Pending Leaves
     */
    public function pending()
    {
        $pending = LeaveRequest::with(['user', 'leaveType'])
            ->where('status', 'pending')
            ->get();

        return response()->json([
            'status' => 'success',
            'data' => $pending
        ]);
    }

    /**
     * Admin: Approve
     */
    public function approve($id)
    {
        $leave = LeaveRequest::findOrFail($id);
        $leave->status = 'approved';
        $leave->approved_by = Auth::id(); // Assuming admin is logged in
        $leave->save();
        
        // Deduct balance
        $balance = LeaveBalance::where('user_id', $leave->user_id)
            ->where('leave_type_id', $leave->leave_type_id)
            ->where('year', \Carbon\Carbon::parse($leave->start_date)->year)
            ->first();

        if ($balance) {
            $balance->used_days += $leave->days_requested;
            $balance->remaining_days -= $leave->days_requested;
            $balance->save();
        }

        return response()->json([
            'status' => 'success',
            'data' => $leave,
            'message' => 'Leave approved.'
        ]);
    }

    /**
     * Admin: Reject
     */
    public function reject(Request $request, $id)
    {
        $leave = LeaveRequest::findOrFail($id);
        $leave->status = 'rejected';
        $leave->rejection_reason = $request->rejection_reason;
        $leave->approved_by = Auth::id();
        $leave->save();

        return response()->json([
            'status' => 'success',
            'data' => $leave,
            'message' => 'Leave rejected.'
        ]);
    }
}
