<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

class TechnetApp
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    // public function handle(Request $request, Closure $next): Response
    // {
    //     return $next($request);
    // }

    public function handle(Request $request, Closure $next)
    {
        // Vérifier si l'utilisateur est authentifié
        if (!$request->user()) {
            abort(401, 'No logged');
        }

        // Vérifier si l'utilisateur a le rôle "admin"
        if (!$request->user()->hasRole('Admin')) {
            abort(403, 'Accès interdit');
        }

        return $next($request);
    }

    
}
