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
        // Leave Types Table
        Schema::create('leave_types', function (Blueprint $table) {
            $table->id();
            $table->string('name'); // Sick, Casual, Annual, etc.
            $table->string('code')->unique();
            $table->integer('default_days')->default(0);
            $table->boolean('is_paid')->default(true);
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });

        // Leave Requests Table
        Schema::create('leave_requests', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->foreignId('leave_type_id')->constrained()->cascadeOnDelete();
            $table->date('start_date');
            $table->date('end_date');
            $table->integer('days_requested');
            $table->text('reason')->nullable();
            $table->string('status')->default('pending'); // pending, approved, rejected
            $table->foreignId('approved_by')->nullable()->constrained('users')->nullOnDelete();
            $table->timestamp('approved_at')->nullable();
            $table->text('admin_remarks')->nullable();
            $table->timestamps();
        });

        // Leave Balances Table
        Schema::create('leave_balances', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->foreignId('leave_type_id')->constrained()->cascadeOnDelete();
            $table->integer('year');
            $table->integer('total_days')->default(0);
            $table->integer('used_days')->default(0);
            $table->integer('remaining_days')->default(0);
            $table->timestamps();

            $table->unique(['user_id', 'leave_type_id', 'year']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('leave_balances');
        Schema::dropIfExists('leave_requests');
        Schema::dropIfExists('leave_types');
    }
};
