<?php

use App\Http\Controllers\UsersController;
use App\Http\Controllers\EmployeController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Spatie\Permission\Middlewares\RoleMiddleware;
use Spatie\Permission\Models\Role;

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

Route::post('register', [UsersController::class, 'register']);
Route::post('login', [UsersController::class, 'login']);
Route::get('logout', [UsersController::class, 'logout'])->middleware('auth:api');

Route::apiResource("employes", EmployeController::class); 
Route::apiResource("users", UsersController::class);
// ->middleware('admin') ;
    // ->middleware(RoleMiddleware::class.':Admin');

// LES ROLES 
Route::post('users/add_role', [UsersController::class, 'assignRole']);
Route::post('users/see_role', [UsersController::class, 'showRole']);

// Route::middleware('auth:api')->group(function () {
//     Route::resource('posts', PostController::class);
// });

