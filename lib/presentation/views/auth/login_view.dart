import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/auth_viewmodel.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Login or create an Account',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),

              const Spacer(),

              const Center(
                child: Text(
                  'Welcome\nTOTAL-X',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    height: 1.1,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0875BE),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              Center(
                child: Image.asset(
                  'assets/images/login_illustration.png',
                  height: 234,
                  fit: BoxFit.contain,
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    side: const BorderSide(color: Color(0xffE0E0E0)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: authViewModel.isLoading
                      ? null
                      : () => authViewModel.signInWithGoogle(),
                  icon: const Icon(
                    Icons.g_mobiledata,
                    size: 32,
                    color: Colors.red,
                  ),
                  label: authViewModel.isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Continue With Google',
                          style: TextStyle(color: Colors.black),
                        ),
                ),
              ),

              const SizedBox(height: 10),

              const Center(
                child: Text(
                  'By Continuing, I agree to TotalX’s Terms and condition &\nprivacy policy',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
