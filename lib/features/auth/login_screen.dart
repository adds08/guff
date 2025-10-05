import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guff/core/routing/route_manager.dart';
import 'package:guff/features/auth/provider/auth_provider.dart';
import 'package:guff/features/auth/register_screen.dart';
import 'package:guff/theme/theme_app.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

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
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter email and password")));
      return;
    }

    try {
      await ref.read(authProviderProvider.notifier).login(email, password);
      isLoggingIn = false;

      ref.read(routerProvider).go('/home');
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login successful!")));
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login failed: $e")));
      setState(() {
        isLoggingIn = false;
      });
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
      headers: [
        AppBar(title: const Text("Login")),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 42.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email input
            TextField(
              placeholder: Text('Enter your email'),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 8),
            // Password input
            TextField(
              placeholder: Text('Enter your password'),
              controller: _passwordController,
              obscureText: _obscurePassword,
            ),
            Gap(16),
            // Login button
            Button.secondary(
              onPressed: isLoggingIn ? null : _login,
              child: isLoggingIn ? CircularProgressIndicator() : const Text("Login", style: TextStyle(color: ThemeApp.white, fontSize: 16)),
            ),
            Gap(24),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const RegistrationScreen()));
              },
              child: Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
