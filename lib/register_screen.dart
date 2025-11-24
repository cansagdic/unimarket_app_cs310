import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //AlertDialog Display
  // This function is called when form validation fails to show a pop-up warning.
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Function executed when the "Sign Up" button is pressed.
  void _submitForm() {
    // Checks if all fields are valid according to their validators.
    if (_formKey.currentState!.validate()) {
      // if it is valid
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration Successful! Redirecting to login screen.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      // Go back to login screen after a short delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    } else {
      //if validation is failed
      // Flutter shows red error messages automatically.
      _showErrorDialog("Please fix the errors marked in red.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Icon(
                Icons.person_add_alt_1,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 20),
              Text(
                "Join UniMarket",
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 30),

              //Name Field and Validation
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                    labelText: 'Full Name', border: OutlineInputBorder()),
                //At least 3 characters
                validator: (value) {
                  if (value == null || value.length < 3) {
                    return 'Name must be at least 3 characters.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              //Validate the email and Email Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    labelText: 'University Email', border: OutlineInputBorder()),
                //Must contain '@'
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Please enter a valid email address.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              //Validate the password, and password 
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Password', border: OutlineInputBorder()),
                //Not empty and at least 6 characters
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please set a password.';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              //Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 50,
                // Tonal button style
                child: FilledButton.tonal(
                  onPressed: _submitForm,
                  child: const Text('Sign Up', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
