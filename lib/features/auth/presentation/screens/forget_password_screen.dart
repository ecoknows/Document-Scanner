import 'dart:io';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:document_scanner/base/widgets/base_text_button.dart';
import 'package:document_scanner/base/widgets/base_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static String name = 'Forgot Password';

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  bool enableButton = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_checkIfValid);
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _checkIfValid() {
    if (emailController.text.isNotEmpty) {
      setState(() => enableButton = true);
    } else {
      setState(() => enableButton = false);
    }
  }

  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
      // Show success message
      AnimatedSnackBar.material('Password reset email sent!',
              duration: Duration(seconds: 4),
              type: AnimatedSnackBarType.success)
          .show(context);

      setState(() {
        emailController.text = "";
        context.pop();
      });
    } on FirebaseAuthException catch (e) {
      // Show error message
      AnimatedSnackBar.material(e.message ?? 'Error sending email',
              duration: Duration(seconds: 2), type: AnimatedSnackBarType.error)
          .show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ForgotPasswordScreen.name),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              BaseTextField(
                label: "Email",
                hint: "john.doe@gmail.com",
                type: BaseTextFieldType.text,
                controller: emailController,
              ),
              const SizedBox(height: 30.0),
              SizedBox(
                width: double.infinity,
                child: BaseTextButton(
                  text: 'Send Password Reset',
                  onPressed: enableButton ? resetPassword : null,
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      const TextSpan(text: "Remembered your password? "),
                      TextSpan(
                        text: 'Sign in',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Navigate to sign-in screen
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
