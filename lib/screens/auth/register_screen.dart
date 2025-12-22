import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(); // şimdilik sadece UI için
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _humanizeAuthError(Object e) {
    final msg = e.toString();
    // Temel, kullanıcı-dostu mesajlar:
    if (msg.contains('email-already-in-use')) return 'This email is already in use.';
    if (msg.contains('invalid-email')) return 'Please enter a valid email address.';
    if (msg.contains('weak-password')) return 'Password is too weak (min 6 chars).';
    if (msg.contains('operation-not-allowed')) return 'Email/Password is not enabled in Firebase.';
    return 'Registration failed. Please try again.';
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _error = "Please fix the errors marked in red.");
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await context.read<AuthProvider>().register(
            _emailController.text.trim(),
            _passwordController.text,
            displayName: _nameController.text.trim(),
          );

      if (!mounted) return;

      // Firebase Auth creates + signs in user automatically.
      // AuthGate will detect the auth state and navigate to the main app.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Do NOT Navigator.pop / push here.
      // Let AuthGate handle navigation.
    } catch (e) {
      setState(() => _error = _humanizeAuthError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
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
              Icon(Icons.person_add_alt_1, size: 80, color: theme.colorScheme.primary),
              const SizedBox(height: 20),
              Text("Join UniMarket", style: theme.textTheme.headlineSmall),
              const SizedBox(height: 30),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().length < 3) {
                    return 'Name must be at least 3 characters.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Please enter a valid email address.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please set a password.';
                  if (value.length < 6) return 'Password must be at least 6 characters.';
                  return null;
                },
              ),
              const SizedBox(height: 15),

              if (_error != null) ...[
                Text(_error!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 10),
              ],

              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.tonal(
                  onPressed: _loading ? null : _submitForm,
                  child: _loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Sign Up', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
