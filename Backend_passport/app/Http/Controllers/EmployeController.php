<?php

namespace App\Http\Controllers;

use App\Helpers\JsonResponse;
use App\Models\Employe;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class EmployeController extends Controller
{
    public function index()
    {
        $employees = Employe::orderBy('updated_at', 'desc')->get();
        $message = "Employee's list";
        $data = (['Employees' => $employees]);
        // La classe -- App/Helpers/JsonResponse -- m'évite les répétitions de message Json
        return JsonResponse::response200($message, $data);
    }
    public function store(Request $request)
    {
        $data = $request->all();
        $validator = Validator::make($data, [
            // <alpha> pour indiquer que <name> ne contient que des lettres 
            'name' => 'required|alpha|max:600',
            'salary' => 'required|integer',
            'job' => 'required|string',
        ]);
        if ($validator->fails()) {
            $error = $validator->errors()->first();
            return JsonResponse::response400($error);
        } else {
            $employee = Employe::create([
                'name' => $request->name,
                'salary' => $request->salary,
                'job' => $request->job
            ]);
            $message = 'New employee  added successfully';
            $data = (['Employee' => $employee]);
            return JsonResponse::response201($message, $data);
        }
    }
    public function show(Employe $employee)
    {
        if ($employee) {
            $message = "Here is the employee";
            return JsonResponse::response200($message, $employee);
        } else {
            $message = "Employee not found";
            return JsonResponse::response404($message);
        }     
    }
    public function update(Request $request, Employe $employee)
    {
        $data = $request->all();
        $validator = Validator::make($data, [
            'name' => 'required|alpha|max:600',
            'salary' => 'required|integer',
            'job' => 'required|alpha',
        ]);
        if ($validator->fails()) {
            $error = $validator->errors()->first();
            return JsonResponse::response400($error);
        } else {
            $employee->update([
                'name' => $request->name,
                'salary' => $request->salary,
                'job' => $request->job
            ]);
            $message = "Employee updated";
            $data = (['Employee' => $employee]);
            return JsonResponse::response200($message, $data);
        }
    }
    public function destroy(Employe $employee)
    {
        $employee->delete();
        $message = "Employee removed";
        $data = 'Nothing';
        return JsonResponse::response200($message, $data);
    }
}
