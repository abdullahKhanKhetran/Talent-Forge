<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class LeaveType extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'code',
        'default_days',
        'is_paid',
        'is_active',
    ];

    protected function casts(): array
    {
        return [
            'is_paid' => 'boolean',
            'is_active' => 'boolean',
        ];
    }

    /**
     * Get leave requests for this type.
     */
    public function leaveRequests()
    {
        return $this->hasMany(LeaveRequest::class);
    }
}
