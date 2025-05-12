import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerificationScreen extends StatefulWidget {
  final String username;
  
  const VerificationScreen({
    super.key,
    required this.username,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _verifyCode() async {
    if (_codeController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter the verification code';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('Sending verification request for username: ${widget.username}');
      print('Verification code: ${_codeController.text}');
      
      final response = await http.post(
        Uri.parse('https://streamsite-ball-wijzer.vercel.app/api/verify-code'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'username': widget.username,
          'code': _codeController.text,
        }),
      );

      print('Response status code: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['error'] != null) {
          setState(() {
            _errorMessage = responseData['error'];
          });
        } else {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email verified successfully!'),
              backgroundColor: Color(0xFF1E88E5),
            ),
          );

          // Navigate to login
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          }
        }
      } else {
        String errorMessage = 'Verification failed. Please try again.';
        try {
          final errorData = jsonDecode(response.body);
          if (errorData['error'] != null) {
            errorMessage = errorData['error'];
          } else if (errorData['message'] != null) {
            errorMessage = errorData['message'];
          }
        } catch (e) {
          print('Error parsing error response: $e');
        }
        setState(() {
          _errorMessage = errorMessage;
        });
      }
    } catch (error) {
      print('Error during verification: $error');
      print('Error type: ${error.runtimeType}');
      if (error is http.ClientException) {
        print('Client exception details: ${error.message}');
      }
      
      String errorMessage = 'Network error. Please check your connection.';
      if (error.toString().contains('SocketException')) {
        errorMessage = 'No internet connection. Please check your network.';
      } else if (error.toString().contains('Connection refused')) {
        errorMessage = 'Could not connect to the server. Please try again later.';
      } else if (error.toString().contains('timeout')) {
        errorMessage = 'Request timed out. Please try again.';
      }
      
      setState(() {
        _errorMessage = errorMessage;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        backgroundColor: const Color(0xFF1E88E5),
      ),
      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              const SizedBox(height: 40),
            const Icon(
              Icons.mark_email_read,
              size: 100,
              color: Color(0xFF1E88E5),
            ),
            const SizedBox(height: 32),
            const Text(
              'Verify your email',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
                'We have sent a verification code to your email address. Please enter the code below.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    labelText: 'Verification Code',
                    hintText: 'Enter the code from your email',
                    prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF1E88E5)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    floatingLabelStyle: const TextStyle(color: Color(0xFF1E88E5)),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Verify Email',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _isLoading
                    ? null
                    : () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF1E88E5),
              ),
              child: const Text(
                'Back to Login',
                style: TextStyle(fontSize: 16),
              ),
            ),
              const SizedBox(height: 40),
          ],
          ),
        ),
      ),
    );
  }
}
