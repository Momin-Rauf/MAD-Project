import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'chat-app.dart';  // Import the home screen or the next screen after login

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatPage()),
            );
        // final response = await http.post(
        //   Uri.parse('https://streamsite-ball-wijzer.vercel.app/api/login'),
        //   headers: <String, String>{
        //     'Content-Type': 'application/json; charset=UTF-8',
        //   },
        //   body: jsonEncode(<String, String>{
        //     'email': _emailController.text,
        //     'password': _passwordController.text,
        //   }),
        // );

        // if (response.statusCode == 200) {
        //   // Successful login
        //   if (mounted) {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       const SnackBar(content: Text('Login successful!')),
        //     );
        //     // Navigate to HomePage after successful login
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => const ChatPage()),
        //     );
        //   }
        // } else {
        //   // Error in login
        //   final errorMessage = jsonDecode(response.body)['error'] ?? 'Invalid email or password';
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text(errorMessage)),
        //   );
        // }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred')),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Add additional email validation if necessary
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
