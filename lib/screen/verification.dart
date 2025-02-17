import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For parsing the JSON response

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final String _username = "Shumail"; // Hardcoding username for now

  bool _isLoading = false;
  String _errorMessage = '';

  // Function to verify the OTP
  Future<void> _verifyOTP() async {
    final otp = _otpController.text.trim();

    if (otp.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter the OTP';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = ''; // Reset error message
    });

    final url = Uri.parse('http://streamsite-ball-wijzer.vercel.app/api/verify-code');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': _username,
          'code': otp,
        }),
      );

      if (response.statusCode == 200) {
        // If the response is successful
        final responseBody = json.decode(response.body);
        if (responseBody['success'] == true) {
          // Assuming the API returns a 'success' field
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('OTP verified successfully!')),
          );
          // Navigate to the next screen or perform other actions
        } else {
          setState(() {
            _errorMessage = 'Invalid OTP code. Please try again.';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to verify OTP. Please try again later.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter the OTP code sent to your email or phone',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'OTP Code',
                  border: OutlineInputBorder(),
                  errorText: _errorMessage.isEmpty ? null : _errorMessage,
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _verifyOTP,
                      child: const Text('Verify'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
