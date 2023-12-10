import 'dart:developer';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/shared_components/toggle_obscure.dart';
import 'package:motors_app/core/styles/styles.dart';
import 'package:motors_app/core/utils/util.dart';
import 'package:motors_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:motors_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:motors_app/presentation/screens/screens.dart';
import 'package:motors_app/presentation/widgets/alert_dialog.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener(
        bloc: BlocProvider.of<AuthBloc>(context),
        listener: (BuildContext context, state) {
          if (state is SuccessAuthState) {
            if (preferences.getString('token') != '') {
              BlocProvider.of<ProfileBloc>(context)
                  .add(LoadProfileEvent(preferences.getString('userId')));

              WidgetsBinding.instance.addPostFrameCallback(
                (_) => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainScreen(
                      selectedIndex: 3,
                    ),
                  ),
                  (Route<dynamic> route) => false,
                ),
              );
            }
          }

          if (state is ErrorAuthState) {
            if (Platform.isIOS) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => cupertinoAlertDialog(
                  onPressedYes: () => Navigator.of(context).pop(),
                  onPressedNo: () => Navigator.of(context).pop(),
                  context: context,
                  title: translations?['error'] ?? 'Error',
                  content: state.message,
                  submitText: translations?['ok'] ?? 'OK',
                  cancelText: translations?['cancel'] ?? 'Cancel',
                ),
              );
            }

            if (Platform.isAndroid) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => materialAlertDialog(
                  onPressedYes: () => Navigator.of(context).pop(),
                  onPressedNo: () => Navigator.of(context).pop(),
                  context: context,
                  title: translations?['error'] ?? 'Error',
                  content: state.message,
                  submitText: translations?['ok'] ?? 'OK',
                  cancelText: translations?['cancel'] ?? 'Cancel',
                ),
              );
            }
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: _widgetBody(state, context),
            );
          },
        ),
      ),
    );
  }

  _widgetBody(AuthState state, BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            'assets/images/login_bg.png',
            fit: BoxFit.fill,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                //Login
                TextFormField(
                  textAlign: TextAlign.left,
                  controller: _loginController,
                  cursorColor: secondaryColor,
                  onChanged: (val) {},
                  validator: (val) {
                    if (_loginController.text == '') {
                      return translations?['fill_the_form'] ?? 'Fill the form';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    enabled: state is! LoadingAuthState,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 0, color: Colors.white),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(color: Colors.red, width: 1),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(color: Colors.red, width: 1),
                    ),
                    isDense: false,
                    hintText: translations!['login'].toString().toCapitalized(),
                  ),
                ),
                const SizedBox(height: 15),
                //Password
                TextFormField(
                  controller: _passwordController,
                  validator: (val) {
                    if (_loginController.text == '') {
                      return translations?['fill_the_form'] ?? 'Fill the form';
                    }
                    return null;
                  },
                  enabled: state is! LoadingAuthState,
                  obscureText: Provider.of<ToggleObscure>(context).isObscure,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(color: Colors.red, width: 1),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(color: Colors.red, width: 1),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () =>
                          Provider.of<ToggleObscure>(context, listen: false)
                              .toggle(),
                      icon: Icon(
                        Provider.of<ToggleObscure>(context).isObscure
                            ? IconsMotors.eyeClose
                            : IconsMotors.eyeShow,
                        size: 16,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 0, color: Colors.white),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    isDense: false,
                    hintText:
                        translations!['password'].toString().toCapitalized(),
                  ),
                ),
                const SizedBox(height: 15),
                //Sign In
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(secondaryColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    onPressed: state is LoadingAuthState
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<AuthBloc>(context).add(
                                LoginEvent(
                                  _loginController.text,
                                  _passwordController.text,
                                ),
                              );
                            }
                          },
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: state is LoadingAuthState
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              translations!['sign_in'] ?? 'Sign In',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                //google
                if (Platform.isAndroid)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(secondaryColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      onPressed: state is LoadingAuthState
                          ? null
                          : () {
                              BlocProvider.of<AuthBloc>(context).add(
                                SignInWithGoogleEvent(), // Trigger Google sign-in event
                              );
                            },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: state is LoadingAuthState
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.google,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    translations!['sign_in_with_google'] ??
                                        'Sign In With Google',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                //apple
                if (Platform.isIOS)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(secondaryColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      onPressed: state is LoadingAuthState
                          ? null
                          : () {
                              BlocProvider.of<AuthBloc>(context).add(
                                SignInWithGoogleEvent(), // Trigger Apple sign-in event
                              );
                            },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: state is LoadingAuthState
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.apple,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    translations!['sign_in_with_apple'] ??
                                        'Sign In With Apple',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),

                const SizedBox(height: 70),
                //OR
                Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        color: Colors.white,
                        endIndent: 10,
                        indent: 130,
                        thickness: 1.5,
                      ),
                    ),
                    Text(
                      translations!['or'] ?? 'OR',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: Colors.white,
                        endIndent: 130,
                        indent: 10,
                        thickness: 1.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                //Sign Up
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent.withOpacity(0.1),
                      side: const BorderSide(
                        width: 2,
                        color: Colors.white,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        translations?['sign_up'] ?? 'Sign Up',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                //By creating
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: Text(
                    translations?['by_creating'] ??
                        "By Creating or logging into an account you're agreeing with out",
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                //Terms & Privacy Statement
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            '${translations?['terms_conditions'] ?? 'Terms & Conditions'}',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => log('Tap Here onTap'),
                        style: const TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(
                        text: ' ${translations!['and'] ?? 'and'} ',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text:
                            '${translations?['privacy_statement'] ?? 'Privacy Statement'}',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => log('Tap Here onTap'),
                        style: const TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
