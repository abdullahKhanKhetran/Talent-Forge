<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // Salary Structures Table
        Schema::create('salary_structures', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->decimal('basic_salary', 12, 2);
            $table->decimal('housing_allowance', 12, 2)->default(0);
            $table->decimal('transport_allowance', 12, 2)->default(0);
            $table->decimal('other_allowances', 12, 2)->default(0);
            $table->decimal('gross_salary', 12, 2);
            $table->date('effective_from');
            $table->date('effective_to')->nullable();
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });

        // Payroll Periods Table
        Schema::create('payroll_periods', function (Blueprint $table) {
            $table->id();
            $table->string('name'); // Jan 2024, Feb 2024, etc.
            $table->date('start_date');
            $table->date('end_date');
            $table->string('status')->default('draft'); // draft, processing, approved, paid
            $table->timestamps();
        });

        // Payslips Table
        Schema::create('payslips', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->foreignId('payroll_period_id')->constrained()->cascadeOnDelete();
            $table->decimal('basic_salary', 12, 2);
            $table->decimal('total_allowances', 12, 2)->default(0);
            $table->decimal('gross_salary', 12, 2);
            $table->decimal('late_deduction', 12, 2)->default(0);
            $table->decimal('absence_deduction', 12, 2)->default(0);
            $table->decimal('other_deductions', 12, 2)->default(0);
            $table->decimal('total_deductions', 12, 2)->default(0);
            $table->decimal('net_salary', 12, 2);
            $table->string('status')->default('draft'); // draft, approved, paid
            $table->text('remarks')->nullable();
            $table->timestamps();

            $table->unique(['user_id', 'payroll_period_id']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('payslips');
        Schema::dropIfExists('payroll_periods');
        Schema::dropIfExists('salary_structures');
    }
};
