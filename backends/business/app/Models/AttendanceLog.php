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
        'check_in',
        'check_out',
        'latitude_in',
        'longitude_in',
        'latitude_out',
        'longitude_out',
        'status',
        'notes',
        'risk_score',
    ];

    protected function casts(): array
    {
        return [
            'date' => 'date',
            'check_in' => 'datetime:H:i:s',
            'check_out' => 'datetime:H:i:s',
            'latitude_in' => 'decimal:8',
            'longitude_in' => 'decimal:8',
            'latitude_out' => 'decimal:8',
            'longitude_out' => 'decimal:8',
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
