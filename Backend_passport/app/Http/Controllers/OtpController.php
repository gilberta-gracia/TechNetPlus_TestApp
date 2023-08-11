<?php

namespace App\Http\Controllers;

use App\Helpers\JsonResponse;
use App\Models\User;
use Illuminate\Http\Request;
use Twilio\Rest\Client;

class OtpController extends Controller
{

    public function sendCode(Request $request)
    {
        $validatedData = $request->validate([
            'phone' => 'required|regex:/^\+[0-9]{10,12}$/|exists:users',
        ]);

        $twilio = new Client(env('TWILIO_ACCOUNT_SID'), env('TWILIO_AUTH_TOKEN'));
        $twilio->verify->v2->services(env('app.twilio_verify_service_sid'))
            ->verifications
            // ->create(['to' => '+15551234567', 'channel' => 'sms']);
            ->create($validatedData['phone'], 'sms');

        return 'Un code d\'authentification a été envoyé à votre numéro de téléphone.';
    }

    public function verifyCode(Request $request)
    {
        $validatedData = $request->validate([
            'phone' => 'required',
            'verification_code' => 'required',
        ]);

        $twilio = new Client(env('TWILIO_ACCOUNT_SID'), env('TWILIO_AUTH_TOKEN'));
        $verificationCheck = $twilio->verify->v2->services(env('app.twilio_verify_service_sid'))
            ->verificationChecks
            ->create( ['to' => $validatedData['phone'], 'code' => $validatedData['verification_code'] ]);

        if ($verificationCheck->status === 'approved') {
            return 'Code d\'authentification valide. Authentification réussie !';
        } else {
            return 'Code d\'authentification invalide. Veuillez réessayer.';
        }
    }

    public function login(Request $request)
    {
        // Validate the phone number
        $validatedData = $request->validate([
            'phone' => 'required|regex:/^\+[0-9]{10,12}$/|exists:users'
        ]);

        // Look up the user with the given phone number
        $user = User::where('phone', $validatedData)->first();
        // If the user is found, generate and send the OTP
        if ($user) {
            // Generate the OTP
            $otp = rand(10000, 99999);
            // Store the OTP in the session
            $request->session()->put('otp', $otp);
            // Send the OTP via SMS using the Twilio SDK
            // (configure your Twilio account details in the .env file)
            $twilio = new Client(env('TWILIO_ACCOUNT_SID'), env('TWILIO_AUTH_TOKEN'));
            $twilio->messages->create($request->phone,  [
                'from' => env('TWILIO_PHONE_NUMBER'),
                'body' => "Your OTP is $otp"
            ]);
            // Redirect to the OTP verification form
            return redirect('/verify-otp');
        } else {
            // If the phone number is not found in the database, display an error message
            // return back()->withErrors(['phone' => 'Phone number not found']);
            $message =  'Phone number not found';
            return JsonResponse::response404($message);
        }
    }

    public function verifyOtp(Request $request)
    {
        // Validate the OTP
        $validatedData = $request->validate([
            // 'otp' => 'required|digits:5'
            'otp' => 'required|digits:5'
        ]);

        // Get the OTP from the session
        $otp = $request->session()->get('otp');
        // Check if the entered OTP is correct
        if ($validatedData == $otp) {
            // If the OTP is correct, log the user in and redirect to the dashboard
            auth()->loginUsingId(1); // replace 1 with the user's actual ID
            return 'succes';
        } else {
            // If the OTP is incorrect, display an error message
            return back()->withErrors(['otp' => 'Incorrect OTP']);
        }
    }
}
