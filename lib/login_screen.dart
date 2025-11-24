import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Key for form validation and state management
  final _formKey = GlobalKey<FormState>();
  // Controllers for text fields to retrieve user input
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Accessing the current theme data for consistent styling
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Displaying a logo fetched from the internet
                Image.network(
                  'https://cdn-icons-png.flaticon.com/512/2232/2232688.png',
                  height: 100,
                  // Coloring the image
                  color: colorScheme.primary,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback icon if the image fails to load
                    return Icon(Icons.account_circle,
                        size: 100, color: colorScheme.primary);
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'UniMarket Login',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 30),

                //Validation and email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Student Email',
                    hintText: 'example@sabanciuniv.edu',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  //Must not be empty and must contain '@'
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email.';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                //Validation of password and password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true, // Hide password input
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  //Must not be empty and at least 6 characters
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password.';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                //Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    onPressed: () {
                      // This block executes only if all validators return null (success).
                      if (_formKey.currentState!.validate()) {
                        // Navigation via named routes
                        // If validation passes, navigate to home page and replace current route.
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                      // If validation fails, Flutter automatically shows red error messages
                    },
                    child:
                    const Text('Login', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 15),

                //Navigate to Sign Up Page 
                TextButton(
                  onPressed: () {
                    //Navigation(Named Routes)
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text('Don\'t have an account? Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
