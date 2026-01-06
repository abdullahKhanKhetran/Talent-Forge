<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Payslip extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'payroll_period_id',
        'basic_salary',
        'total_allowances',
        'gross_salary',
        'late_deduction',
        'absence_deduction',
        'other_deductions',
        'total_deductions',
        'net_salary',
        'status',
        'remarks',
    ];

    protected function casts(): array
    {
        return [
            'basic_salary' => 'decimal:2',
            'total_allowances' => 'decimal:2',
            'gross_salary' => 'decimal:2',
            'late_deduction' => 'decimal:2',
            'absence_deduction' => 'decimal:2',
            'other_deductions' => 'decimal:2',
            'total_deductions' => 'decimal:2',
            'net_salary' => 'decimal:2',
        ];
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function payrollPeriod()
    {
        return $this->belongsTo(PayrollPeriod::class);
    }
}
