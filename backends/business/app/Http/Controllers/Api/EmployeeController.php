<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rule;

class EmployeeController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        // Fetch users with role 'employee'
        $employees = User::where('role', 'employee')->with('department')->get();
        return response()->json(['data' => $employees]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8',
            'department_id' => 'nullable|exists:departments,id',
            'designation' => 'nullable|string|max:255',
            'employee_code' => 'nullable|string|max:50|unique:users',
            'phone' => 'nullable|string|max:20',
        ]);

        $validated['role'] = 'employee';
        $validated['password'] = Hash::make($validated['password']);
        $validated['status'] = 'active';

        $employee = User::create($validated);

        return response()->json(['message' => 'Employee created successfully', 'data' => $employee], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $employee = User::with('department')->findOrFail($id);
        return response()->json(['data' => $employee]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $employee = User::findOrFail($id);

        $validated = $request->validate([
            'name' => 'sometimes|required|string|max:255',
            'email' => ['sometimes', 'required', 'email', Rule::unique('users')->ignore($employee->id)],
            'department_id' => 'nullable|exists:departments,id',
            'designation' => 'nullable|string|max:255',
            'employee_code' => ['nullable', 'string', 'max:50', Rule::unique('users')->ignore($employee->id)],
            'phone' => 'nullable|string|max:20',
            'status' => 'nullable|in:active,inactive',
        ]);

        $employee->update($validated);

        return response()->json(['message' => 'Employee updated successfully', 'data' => $employee]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $employee = User::findOrFail($id);
        $employee->delete();

        return response()->json(['message' => 'Employee deleted successfully']);
    }
}
