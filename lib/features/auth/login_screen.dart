import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guff/core/routing/route_manager.dart';
import 'package:guff/features/auth/provider/auth_provider.dart';
import 'package:guff/features/auth/register_screen.dart';
import 'package:guff/theme/theme_app.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool isLoggingIn = false;

  Future<void> _login() async {
    setState(() {
      isLoggingIn = true;
    });
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter email and password")));
      return;
    }

    try {
      await ref.read(authProviderProvider.notifier).login(email, password);
      setState(() {
        isLoggingIn = true;
      });
      ref.read(routerProvider).go('/home');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login successful!")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login failed: $e")));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    isLoggingIn = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeApp.white,
      appBar: AppBar(title: const Text("Login"), centerTitle: true, backgroundColor: ThemeApp.greenPale),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email input
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email_outlined), border: OutlineInputBorder()),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Password input
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: const Icon(Icons.lock_outline),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Login button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: ThemeApp.greenPale, padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: isLoggingIn ? null : _login,
                child: isLoggingIn
                    ? CircularProgressIndicator()
                    : const Text("Login", style: TextStyle(color: ThemeApp.white, fontSize: 16)),
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const RegistrationScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text("Don't have an account? Register", style: TextStyle(color: ThemeApp.greenPale)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
