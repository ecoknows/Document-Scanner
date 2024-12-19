import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:document_scanner/base/widgets/base_appbar.dart';
import 'package:document_scanner/base/widgets/base_scaffold.dart';
import 'package:document_scanner/base/widgets/base_text_button.dart';
import 'package:document_scanner/base/widgets/base_textfield.dart';
import 'package:document_scanner/features/auth/core/exceptions/auth_execptions.dart';
import 'package:document_scanner/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:document_scanner/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:document_scanner/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:document_scanner/features/documents/presentation/blocs/get_scanned_documents_bloc.dart';
import 'package:document_scanner/features/documents/presentation/blocs/upload_document_to_cloud_bloc.dart';
import 'package:document_scanner/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignInScreen extends StatefulWidget {
  static String name = 'Sign In';

  const SignInScreen({
    super.key,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool enableButton = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_checkIfValid);
    passwordController.addListener(_checkIfValid);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _checkIfValid() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      setState(() => enableButton = true);
    } else {
      setState(() => enableButton = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState is AuthSuccess) {
          AnimatedSnackBar.material(
            authState.message,
            type: AnimatedSnackBarType.success,
            duration: const Duration(seconds: 5),
            mobileSnackBarPosition: MobileSnackBarPosition.bottom,
          ).show(context);

          context
              .read<UploadDocumentToCloudBloc>()
              .add(UploadDocumentToCloudStarted());

          context
              .read<GetScannedDocumentsBloc>()
              .add(GetScannedDocumentsStarted(showLoadingIndicator: true));

          context.goNamed(HomeScreen.name);
        } else if (authState is AuthFail) {
          AuthException e = authState.exception;

          AnimatedSnackBar.material(
            e.message,
            type: AnimatedSnackBarType.error,
            duration: const Duration(seconds: 5),
            mobileSnackBarPosition: MobileSnackBarPosition.bottom,
          ).show(context);
        }
      },
      child: BaseScaffold(
        appBar: BaseAppBar(
          title: Text(SignInScreen.name),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: [
              BaseTextField(
                label: "Email",
                hint: "john.doe@gmail.com",
                type: BaseTextFieldType.text,
                controller: emailController,
              ),
              BaseTextField(
                label: "Password",
                hint: "*******",
                type: BaseTextFieldType.text,
                obscureText: true,
                controller: passwordController,
              ),
              const SizedBox(
                height: 30.0,
              ),
              SizedBox(
                width: double.infinity,
                child: BaseTextButton(
                  text: 'Login',
                  onPressed: enableButton
                      ? () {
                          context.read<AuthBloc>().add(
                                SignInUserStarted(
                                  email: emailController.text,
                                  password: passwordController.text,
                                ),
                              );
                        }
                      : null,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: 'Forget Password?',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // context.pushNamed(SignUpScreen.name);
                            context.pushNamed(ForgotPasswordScreen.name);
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
