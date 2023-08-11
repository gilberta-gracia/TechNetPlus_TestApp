<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Spatie\Permission\Models\Role;

class RoleController extends Controller
{

    public function assignRole(Request $request)
    {
      $userName = $request->user_name;
      $user = User::where('name', $userName)->firstOrFail();
      $roleName = $request->role_name;
      $role = Role::where('name', $roleName)->firstOrFail();
      if ($user && $role) {
        $user->assignRole($role);
        // $user->syncPermissions($role->permissions);
        return response()->json([
          'message' => 'Role assigned to user successfully.',
          'user' => $userName,
          'role' => $roleName
        ], 200);
      }else {
        return response()->json([
          'message' => 'User or role doesn\'t exist'], 404);
    }
    }

    public function showRole(Request $request)
    {
      $userName = $request->user_name;
      $user = User::where('name', $userName)->firstOrFail(); 
      if (!$user) {
          return response()->json(['error' => 'User not found'], 404);
      }
      $role = $user->getRoleNames();
      if (!$role) {
          return response()->json(['error' => 'Role not found'], 404);
      }
      return response()->json([
        'message' => 'User\'s role found',
        'role' => $role,
      ], 200);
  }


    public function removeRole(Request $request) {
        {
          $userName = $request->user_name;
          $user = User::where('name', $userName)->firstOrFail(); 
          $roleName = $request->role_name;
          $role = Role::where('name', $roleName)->firstOrFail();
          if ($user && $role) {
            $user->roles()->detach($role);
            return response()->json(['message' => ' User\'s role deleted successfully.'], 200);
          }else {
            return response()->json(['error' => 'Content not found.'], 404);
          }
        } 
      }
}
