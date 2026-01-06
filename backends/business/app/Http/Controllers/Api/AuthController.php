<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    /**
     * Register a new user.
     */
    public function register(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|string|min:8|confirmed',
            'role' => 'sometimes|string|in:admin,employee',
            'department_id' => 'sometimes|exists:departments,id',
            'designation' => 'sometimes|string|max:255',
            'phone' => 'sometimes|string|max:20',
        ]);

        $user = User::create([
            'name' => $validated['name'],
            'email' => $validated['email'],
            'password' => Hash::make($validated['password']),
            'role' => $validated['role'] ?? 'employee',
            'department_id' => $validated['department_id'] ?? null,
            'designation' => $validated['designation'] ?? null,
            'phone' => $validated['phone'] ?? null,
            'status' => 'active',
        ]);

        $token = $user->createToken('TalentForge')->accessToken;

        return response()->json([
            'success' => true,
            'message' => 'User registered successfully',
            'user' => $user,
            'token' => $token,
        ], 201);
    }

    /**
     * Login user and return token.
     */
    public function login(Request $request)
    {
        $validated = $request->validate([
            'email' => 'required|email',
            'password' => 'required|string',
        ]);

        $user = User::where('email', $validated['email'])->first();

        if (!$user || !Hash::check($validated['password'], $user->password)) {
            throw ValidationException::withMessages([
                'email' => ['The provided credentials are incorrect.'],
            ]);
        }

        if ($user->status !== 'active') {
            return response()->json([
                'success' => false,
                'message' => 'Your account is not active. Please contact admin.',
            ], 403);
        }

        $token = $user->createToken('TalentForge')->accessToken;

        return response()->json([
            'success' => true,
            'message' => 'Login successful',
            'user' => $user->load('department'),
            'token' => $token,
        ]);
    }

    /**
     * Logout user (revoke token).
     */
    public function logout(Request $request)
    {
        $request->user()->token()->revoke();

        return response()->json([
            'success' => true,
            'message' => 'Logged out successfully',
        ]);
    }

    /**
     * Get authenticated user profile.
     */
    public function me(Request $request)
    {
        return response()->json([
            'success' => true,
            'user' => $request->user()->load('department'),
        ]);
    }
}
