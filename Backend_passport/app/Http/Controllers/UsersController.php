<?php

namespace App\Http\Controllers;
use App\Helpers\JsonResponse;
use App\Models\User;
use Illuminate\Http\Request;
class UsersController extends Controller
{
  public function index()
  {
      $users = User::orderBy('updated_at', 'desc')->get();      
      $message = "Liste des utilisateurs";
      JsonResponse::response200($message, $users);
  }

  public function store(Request $request)
    {
        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => $request->password
        ]);
        $message = "Utilisateur ajouté avec succès";
        JsonResponse::response200($message, $user);
    }

    public function show(User $user)
    {
        $message = "Employé modifié";
        JsonResponse::response200($message, $user);
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
  }