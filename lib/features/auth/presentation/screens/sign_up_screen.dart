import 'dart:io';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:document_scanner/base/widgets/base_appbar.dart';
import 'package:document_scanner/base/widgets/base_scaffold.dart';
import 'package:document_scanner/base/widgets/base_text_button.dart';
import 'package:document_scanner/base/widgets/base_textfield.dart';
import 'package:document_scanner/features/auth/core/exceptions/auth_execptions.dart';
import 'package:document_scanner/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:document_scanner/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:document_scanner/features/documents/presentation/blocs/get_scanned_documents_bloc.dart';
import 'package:document_scanner/features/documents/presentation/blocs/upload_document_to_cloud_bloc.dart';
import 'package:document_scanner/features/home/presentation/screens/home_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  static String name = 'Sign Up';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool enableButton = false;

  PlatformFile? pickedFile;

  @override
  void initState() {
    super.initState();
    firstNameController.addListener(_checkIfValid);
    lastNameController.addListener(_checkIfValid);
    emailController.addListener(_checkIfValid);
    passwordController.addListener(_checkIfValid);
    confirmPasswordController.addListener(_checkIfValid);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _checkIfValid() {
    if (firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        pickedFile != null) {
      setState(() => enableButton = true);
    } else {
      setState(() => enableButton = false);
    }
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });

    _checkIfValid();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: Text(SignInScreen.name),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              if (pickedFile != null)
                Center(
                  child: InkWell(
                    onTap: selectFile,
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 80.0,
                      backgroundImage: FileImage(File(pickedFile!.path!)),
                    ),
                  ),
                ),
              if (pickedFile == null)
                Center(
                  child: BaseTextButton(
                    text: "Select Profile Image",
                    onPressed: selectFile,
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(59),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                    ),
                  ),
                ),
              BaseTextField(
                label: "First Name",
                hint: "John",
                type: BaseTextFieldType.text,
                controller: firstNameController,
              ),
              BaseTextField(
                label: "Last Name",
                hint: "Doe",
                type: BaseTextFieldType.text,
                controller: lastNameController,
              ),
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
              BaseTextField(
                label: "Confirm Password",
                hint: "*******",
                type: BaseTextFieldType.text,
                obscureText: true,
                controller: confirmPasswordController,
              ),
              const SizedBox(
                height: 30.0,
              ),
              SizedBox(
                width: double.infinity,
                child: BaseTextButton(
                  text: 'Sign Up',
                  onPressed: enableButton
                      ? () {
                          context.read<AuthBloc>().add(
                                SignUpUserStarted(
                                  firstName: firstNameController.text,
                                  lastName: lastNameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  confirmPassword:
                                      confirmPasswordController.text,
                                  profileImage: pickedFile,
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
                      const TextSpan(
                        text: "Already have an account?",
                      ),
                      const WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: SizedBox(width: 4),
                      ),
                      TextSpan(
                        text: 'Sign in',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.goNamed(SignInScreen.name);
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
