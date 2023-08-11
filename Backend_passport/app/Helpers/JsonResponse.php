<?php

namespace App\Helpers;

class JsonResponse
{
    public static function response200($message, $data)
    {
        return response()->json([ 
            'message' => $message, 
            'data' => $data
        ], 200);
    }
    public static function response201($message, $data)
    {
        return response()->json([ 
            'message' => $message, 
            'data' => $data
        ], 201);
    }
    public static function response400($error)
    {
        return response()->json([ 
            'success' => false, 
            'message' => $error
        ], 400);
    }
    public static function response401($error)
    {
        return response()->json([ 
            'success' => false, 
            'message' => $error
        ], 401);
    }

    public static function response404($error)
    {
        return response()->json([ 
            'message' => $error
        ], 404);
    }
}
