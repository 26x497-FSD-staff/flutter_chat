// lib/features/auth/presentation/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String? _error;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  if (_error != null)
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    onSaved: (v) => _email = v!.trim(),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'กรุณาใส่อีเมล' : null,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (v) => _password = v!.trim(),
                    validator: (v) =>
                        v == null || v.length < 6 ? 'อย่างน้อย 6 ตัวอักษร' : null,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: isLoading ? null : _onLoginPressed,
                    child: const Text('Login with Email'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => context.go('/signup'),
                    child: const Text('ยังไม่มีบัญชี? สมัครใช้งาน'),
                  ),
                  const SizedBox(height: 8),
                  const Divider(
                      height: 2,
                      thickness: 2,
                      indent: 20,
                      endIndent: 0,
                      color: Colors.black54,
                    ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: isLoading ? null : _onGoogleSignInPressed,
                    child: const Text('Login with Google'),
                  ),
                  
                ],
              ),
            ),
          ),
          if (isLoading)
            const ColoredBox(
              color: Colors.black26,
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Future<void> _onLoginPressed() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _error = null);

    try {
      await ref
          .read(authControllerProvider.notifier)
          .signInWithEmail(_email, _password);
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  Future<void> _onGoogleSignInPressed() async {
    setState(() => _error = null);
    try {
      await ref.read(authControllerProvider.notifier).signInWithGoogle();
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }
}