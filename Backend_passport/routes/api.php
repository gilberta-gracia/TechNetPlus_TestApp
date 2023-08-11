<?php

use App\Http\Controllers\UsersController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\RoleController;
use App\Http\Controllers\OtpController;
use App\Http\Controllers\EmployeController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::controller(AuthController::class)->group(function () {
    Route::post('login', 'login');
    Route::post('register', 'register');
    Route::post('logout', 'logout');
});

Route::controller(OtpController::class)->group(function () {
    Route::post('sendCode', 'sendCode');
    Route::post('verifyCode', 'verifyCode');
});

Route::middleware('auth:api')->group(function () {
    Route::apiResource("employees", EmployeController::class); 
    Route::apiResource("users", UsersController::class);

    // LES ROLES 
    Route::post('users/add_role', [RoleController::class, 'assignRole']);
    Route::post('users/see_role', [RoleController::class, 'showRole']);
    Route::post('users/delete_role', [RoleController::class, 'removeRole']);    
});


