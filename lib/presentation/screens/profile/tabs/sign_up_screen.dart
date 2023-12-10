import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/shared_components/image_picker.dart';
import 'package:motors_app/core/shared_components/toggle_obscure.dart';
import 'package:motors_app/core/styles/styles.dart';
import 'package:motors_app/core/utils/util.dart';
import 'package:motors_app/data/models/form_reg/form_reg.dart';
import 'package:motors_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:motors_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:motors_app/presentation/screens/image_detail/image_detail_screen.dart';
import 'package:motors_app/presentation/screens/main_screens.dart';
import 'package:motors_app/presentation/screens/screens.dart';
import 'package:motors_app/presentation/widgets/alert_dialog.dart';
import 'package:motors_app/presentation/widgets/app_bar_icon.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  static const routeName = 'signUpScreen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final List<TextEditingController> _controllers = [];
  final TextEditingController avatarController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translations?['registration'] ?? 'Registration',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
        leading: AppBarIcon(
          iconData: IconsMotors.arrow_back,
          onTap: () {
            Provider.of<ImagePickerProvider>(context, listen: false)
                .deleteImg();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const SignInScreen(),
              ),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      body: BlocListener(
        bloc: BlocProvider.of<AuthBloc>(context),
        listener: (BuildContext context, state) {
          if (state is SuccessAuthState) {
            if (preferences.getString('token') != '') {
              Provider.of<ImagePickerProvider>(context, listen: false)
                  .deleteImg();
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

          if (state is ErrorSignUpState) {
            if (Platform.isIOS) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => cupertinoAlertDialog(
                  context: context,
                  title: translations?['error'] ?? 'Error',
                  content: state.message,
                  submitText: translations?['ok'] ?? 'OK',
                  cancelText: translations?['cancel'] ?? 'Cancel',
                  onPressedYes: () => Navigator.of(context).pop(),
                  onPressedNo: () => Navigator.of(context).pop(),
                ),
              );
            }
            if (Platform.isAndroid) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => materialAlertDialog(
                  context: context,
                  title: translations?['error'] ?? 'Error',
                  content: state.message,
                  submitText: translations?['ok'] ?? 'OK',
                  cancelText: translations?['cancel'] ?? 'Cancel',
                  onPressedYes: () => Navigator.of(context).pop(),
                  onPressedNo: () => Navigator.of(context).pop(),
                ),
              );
            }
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Form(
                key: _formKey,
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: itemList.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(thickness: 1.5),
                          itemBuilder: (BuildContext ctx, int index) {
                            _controllers.add(TextEditingController());

                            return _buildBodyForm(
                              index,
                              _controllers[index],
                              context,
                            );
                          },
                        ),
                        const Divider(thickness: 1.5),
                        //Avatar Field
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15.0, right: 20, left: 10),
                          child: Row(
                            children: [
                              Text(
                                translations?['avatar'] ?? 'AVATAR',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: TextFormField(
                                  controller: avatarController,
                                  readOnly: true,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ImageDetailScreen(),
                                    ),
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xffe9eef0),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 0, color: Colors.white),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    isDense: true,
                                    hintText: Provider.of<ImagePickerProvider>(
                                                    context)
                                                .image !=
                                            null
                                        ? Provider.of<ImagePickerProvider>(
                                                context)
                                            .image
                                            ?.path
                                            .toString()
                                        : translations?['upload_image'] ??
                                            'Press upload image',
                                    hintStyle: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        //Sign Up Button
                        _buildSignUpButton(state, context),
                      ],
                    ),
                  ),
                ));
          },
        ),
      ),
      bottomNavigationBar: const SizedBox(height: 0),
    );
  }

  _buildBodyForm(
      int index, TextEditingController controllerTxt, BuildContext context) {
    FormReg item = itemList[index];

    return Padding(
      padding: const EdgeInsets.only(top: 15.0, right: 20, left: 10),
      child: Row(
        children: [
          Text(
            '${item.name} ${item.required == '' ? '' : item.required}',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: TextFormField(
              controller: controllerTxt,
              keyboardType: item.keyboardType,
              readOnly: item.imgValidate == true ? true : false,
              obscureText: item.obscure == true
                  ? Provider.of<ToggleObscure>(context).isObscureSingUp
                  : item.obscure,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xffe9eef0),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 0, color: Colors.white),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.red, width: 1),
                ),
                errorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.red, width: 1),
                ),
                isDense: true,
                hintStyle: const TextStyle(
                  fontSize: 12,
                ),
                suffixIcon: IconButton(
                  icon: Provider.of<ToggleObscure>(context).isObscureSingUp
                      ? item.suffixIcon
                      : item.suffixIcon,
                  onPressed: item.obscure == false
                      ? null
                      : () {
                          Provider.of<ToggleObscure>(context, listen: false)
                              .toggleSignUp()
                              .then((value) {
                            if (value) {
                              item.suffixIcon = const Icon(IconsMotors.eyeShow);
                            } else {
                              item.suffixIcon =
                                  const Icon(IconsMotors.eyeClose);
                            }
                          });
                        },
                ),
              ),
              inputFormatters: item.inputFormat,
              validator: (val) {
                if (item.required != '') {
                  if (_controllers[index].text == '') {
                    return translations?['fill_the_form'] ?? 'Fill the form';
                  }
                }

                if (item.emailValidate == true) {
                  if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(_controllers[index].text)) {
                    return translations?['email_error'] ??
                        'Fill the form email correctly';
                  }
                }

                if (item.phoneValidate == true) {
                  if (_controllers[5].text.length < 8) {
                    return translations?['password_error'] ??
                        'The password field must not be less than 8 characters';
                  }
                }

                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildSignUpButton(AuthState state, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(mainColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
        onPressed: state is LoadingSignUpState
            ? null
            : () async {
                if (_formKey.currentState!.validate()) {
                  var login = _controllers[0].text;
                  var firstName = _controllers[1].text;
                  var lastName = _controllers[2].text;
                  var phone = _controllers[3].text;
                  var email = _controllers[4].text;
                  var password = _controllers[5].text;

                  BlocProvider.of<AuthBloc>(context).add(
                    SignUpEvent(
                      login: login,
                      name: firstName,
                      surname: lastName,
                      phone: phone,
                      email: email,
                      password: password,
                      avatar: Provider.of<ImagePickerProvider>(context,
                              listen: false)
                          .image,
                    ),
                  );
                }
              },
        child: Padding(
          padding: const EdgeInsets.all(17.0),
          child: state is LoadingSignUpState
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
              : Text(translations?['sign_up'] ?? 'Sign Up'),
        ),
      ),
    );
  }
}
