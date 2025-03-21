<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class () extends Migration {
    public function up(): void
    {
        Schema::table('ec_products', function (Blueprint $table): void {
            $table->string('stock_status')->default('in_stock')->after('with_storehouse_management')->nullable();
        });
    }

    public function down(): void
    {
        Schema::table('ec_products', function (Blueprint $table): void {
            $table->dropColumn('stock_status');
        });
    }
};
