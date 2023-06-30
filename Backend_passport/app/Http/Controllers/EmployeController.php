<?php

namespace App\Http\Controllers;

use App\Models\Employe;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class EmployeController extends Controller
{
    public function index()
    {
            $employes = Employe::all();
            return response($employes);
            return response()->json([
                'success' => true,
                'message' => $employes
            ]);
    }
    public function store(Request $request)
    {
        $employe = Employe::create([
            'nom' => $request->nom,
            'salaire' => $request->salaire,
            'poste' => $request->poste
        ]);
        // return $employe;
        return response($employe);
    }
    public function show(Employe $employe)
    {
        return response($employe);
    }
    public function update(Request $request, Employe $employe)
    {
        $employe->update([
            'nom' => $request->nom,
            'salaire' => $request->salaire,
            'poste' => $request->poste
        ]);
        return response();
    }
    public function destroy(Employe $employe)
    {
        $employe->delete();        
        return response();
    }
}
