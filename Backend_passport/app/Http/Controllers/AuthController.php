<?php

namespace App\Http\Controllers;

use App\Helpers\JsonResponse;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
  /**
   * Register api.
   *
   * @return \Illuminate\Http\Response
   */

  public function __construct()
  {
    $this->middleware('auth:api', ['except' => ['login', 'register']]);
  }

  public function register(Request $request)
  {
    $data = $request->all();
    $validator = Validator::make($data, [
      'name' => 'required|string|max:600',
      'phone' => 'required|regex:/^\+[0-9]{10,12}$/',
      'email' => 'required|email|unique:users',
      'password' => 'required|min:8',
    ]);
    if ($validator->fails()) {
      $error = $validator->errors()->first();
      return JsonResponse::response400($error);
    } else {
      $user = User::create([
        'name' => $request->name,
        'phone' => $request->phone,
        'email' => $request->email,
        'password' => Hash::make($request->password),
      ]);
      $message = 'User created successfully';
      $data = (['User' => $user]);
      return JsonResponse::response201($message, $data);
    }
  }

  public function login(Request $request)
  {
    $data = $request->all();
    $credentials = $request->validate([
      'email' => 'required|string|email',
      'password' => 'required|string',
    ]);
    if (auth()->attempt($credentials)) {
      $user = Auth::user();
      if ($user instanceof User) {
        $user['token'] = $user->createToken('Laravelia')->accessToken;
        $message = 'User connected';
        $data = ([
          'User' => $user,
          // 'token' => $success,
          // 'user' => $user,
          // 'role' => $role
        ]);
        return JsonResponse::response200($message, $data);
      }
    } else {
      $message =  'Invalid credentials';
      return JsonResponse::response400($message);
    }
  }

  public function logout()
  {
    $user = Auth::user();
    if ($user instanceof User) {
      $user->tokens()->delete();
      $message = 'Successfully logged out';
      $data = 'Nothing';
      return JsonResponse::response200($message, $data);
    } else {
      $message = 'Unable to logout';
      return JsonResponse::response401($message);
    }
  }

  // public function login(Request $request)
  // {
  //   if (Auth::attempt(['email' => request('email'), 'password' => request('password')])) {
  //     $user = Auth::user();
  //     if ($user instanceof User) {
  //       $success['token'] = $user->createToken('appToken')->accessToken;
  //       $role = $user->getRoleNames();
  //       //After successfull authentication, notice how I return json parameters
  //       $data =[
  //         'token' => $success,
  //         'user' => $user,
  //         'role' => $role
  //       ];
  //       $message = 'User connected';
  //       return JsonResponse::response200($message, $data);
  //     } 
  //   }else {
  //     $errors = 'Invalid Email or Password';
  //     JsonResponse::response400($errors);
  //   }
  // }
}
