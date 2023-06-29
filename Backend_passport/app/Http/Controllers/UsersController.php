<?php

namespace App\Http\Controllers;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Spatie\Permission\Models\Role;

class UsersController extends Controller
{
    
    /**
     * Register api.
     *
     * @return \Illuminate\Http\Response
     */
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
          'name'=>'required',
            'email' => 'required|email|unique:users',
            'password' => 'required',
        ]);
        if ($validator->fails()) {
          return response()->json([
            'success' => false,
            'message' => $validator->errors(),
          ], 401);
        }
        $input = $request->all();
        $input['password'] = bcrypt($input['password']);
        $user = User::create($input);
        $success['token'] = $user->createToken('appToken')->accessToken;
        return response()->json([
          'success' => true,
          'token' => $success,
          'user' => $user
      ]);
    }

    public function login(Request $request)
    {
        if (Auth::attempt(['email' => request('email'), 'password' => request('password')])) {
            $user = Auth::user();
            if ($user instanceof User) {
                $success['token'] = $user->createToken('appToken')->accessToken;
                //After successfull authentication, notice how I return json parameters
                 return response()->json([
                   'success' => true,
                   'token' => $success,
                   'user' => $user
               ]);
            }else{
                print('error');
            }           
        } else {
       //if authentication is unsuccessfull, notice how I return json parameters
          return response()->json([
            'success' => false,
            'message' => 'Invalid Email or Password',
        ], 401);
        }
    }

    public function logout()
  {
    $user = Auth::user();
    if ($user instanceof User) {
      $user ->token()->revoke();
      return response()->json([
        'success' => true,
        'message' => 'Logout successfully'
    ]);
    }else {
      return response()->json([
        'success' => false,
        'message' => 'Unable to Logout'
      ]);
    } 
  }
  public function index()
  {
      $users = User::all();
      return response($users);
  }

  public function store(Request $request)
    {
        $users = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => $request->password
        ]);
        return response($users);
    }

    public function show(User $users)
    {
        return response($users);
    }

    public function update(Request $request, User $user)
    {        
        $user->update([
          'name' => $request->name,
          'email' => $request->email,
          'password' => $request->password
        ]);
        return response();
    }

    public function destroy(  User $user)
    {     
        // hasPermissionTo('delete-users')
        // if ($user->hasRole('Admin')) {
        $user->delete();        
        return response()->json(['message' => 'Post deleted'], 200);         
    }

  public function assignRole(Request $request)
    {
      $nom = $request->user_name;
      $user = User::where('name', $nom)->firstOrFail();
        $name = $request->role_name;
        $role = Role::where('name', $name)->firstOrFail();
        if ($user && $role) {
        $user->assignRole($role);
        $user->syncPermissions($role->permissions);
        return response()->json(['message' => 'Rôle attribué avec succès.']);
      }else {
        return response()->json(['message' => 'L\'utilisateur ou le rôle n\'existe pas'], 404);
    }

    }

public function showRole(Request $request)
    {
      $nom = $request->user_name;
      $user = User::where('name', $nom)->firstOrFail(); 
        if (!$user) {
            return response()->json(['error' => 'Utilisateur non trouvé'], 404);
        }
        $role = $user->getRoleNames();

        if (!$role) {
            return response()->json(['error' => 'Rôle non trouvé'], 404);
        }
        return response()->json(['role' => $role]);
    }

}
