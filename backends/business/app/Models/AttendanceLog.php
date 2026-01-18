<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class AttendanceLog extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'date',
        'check_in_time',
        'check_out_time',
        'working_hours',
        'location_data',
        'status',
        'notes',
        'risk_score',
    ];

    protected function casts(): array
    {
        return [
            'date' => 'date',
            'check_in_time' => 'datetime',
            'check_out_time' => 'datetime',
            'location_data' => 'array',
            'working_hours' => 'float',
            'risk_score' => 'decimal:2',
        ];
    }

    /**
     * Get the user that owns the attendance log.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
