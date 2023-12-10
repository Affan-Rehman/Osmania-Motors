import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/shared_components/components.dart';
import 'package:motors_app/core/styles/styles.dart';
import 'package:motors_app/data/models/user/user.dart';
import 'package:motors_app/presentation/bloc/add_car/add_car_bloc.dart';
import 'package:motors_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:motors_app/presentation/screens/screens.dart';
import 'package:motors_app/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key, required this.author}) : super(key: key);

  final Author author;

  static const routeName = 'editProfileScreen';

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _login = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _surname = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  late AuthBloc authBloc;

  var userToken = preferences.get('token');

  @override
  void initState() {
    _login = TextEditingController(text: widget.author.username ?? '');
    _name = TextEditingController(text: widget.author.name ?? '');
    _surname = TextEditingController(text: widget.author.lastName ?? '');
    _phone = TextEditingController(text: widget.author.phone ?? '');
    _email = TextEditingController(text: widget.author.email ?? '');
    _password = TextEditingController(text: preferences.getString('password'));
    authBloc = BlocProvider.of<AuthBloc>(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translations!['edit_profile'] ?? 'Edit Profile',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
        leading: AppBarIcon(
          iconData: IconsMotors.arrow_back,
          onTap: () {
            Provider.of<ImagePickerProvider>(context, listen: false).deleteImg();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlocListener(
        bloc: authBloc,
        listener: (BuildContext context, state) {
          if (state is UpdatedUserState) {
            if (preferences.getString('token') != '') {
              Provider.of<ImagePickerProvider>(context, listen: false).deleteImg();
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
        child: Form(
          key: _formKey,
          child: SafeArea(
            child: ListView(
              children: [
                //Login
                EditFormCard(
                  title: translations?['login'] ?? 'LOGIN',
                  readOnly: true,
                  controller: _login,
                ),
                const Divider(thickness: 1),
                //FirstName
                EditFormCard(
                  title: translations?['first_name'] ?? 'FIRST NAME',
                  controller: _name,
                ),
                const Divider(thickness: 1),
                //LastName
                EditFormCard(
                  title: translations?['last_name'] ?? 'LAST NAME',
                  controller: _surname,
                ),
                const Divider(thickness: 1),
                //Phone
                EditFormCard(
                  title: translations?['phone'] ?? 'PHONE',
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                ),
                const Divider(thickness: 1),
                //Email
                EditFormCard(
                  title: translations?['email'] ?? 'EMAIL',
                  controller: _email,
                ),
                const Divider(thickness: 1),
                //Password
                EditFormCard(
                  title: translations?['password'] ?? 'PASSWORD',
                  readOnly: true,
                  obscureText: Provider.of<ToggleObscure>(context).isObscureEditProfile,
                  controller: _password,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return translations?['fill_the_form'] ?? 'Fill the form';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    onPressed: () => Provider.of<ToggleObscure>(context, listen: false).toggleEditProfile(),
                    icon: Icon(Provider.of<ToggleObscure>(context).isObscureEditProfile ? IconsMotors.eyeShow : IconsMotors.eyeClose),
                  ),
                ),
                const Divider(thickness: 1),
                //Avatar
                EditFormCard(
                  title: translations?['avatar'] ?? 'AVATAR',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ImageDetailScreen(),
                    ),
                  ),
                  readOnly: true,
                  hintText: Provider.of<ImagePickerProvider>(context).image != null
                      ? Provider.of<ImagePickerProvider>(context).image?.path.toString()
                      : translations?['upload_image'] ?? 'Press upload image',
                  suffixIcon: const Icon(IconsMotors.photo),
                ),
                const Divider(thickness: 1),
                //Update Button
                _buildUpdateInfoButton(),
                //Delete Button
                _buildDeleteAccount(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const SizedBox(height: 0),
    );
  }

  BlocBuilder<AuthBloc, AuthState> _buildUpdateInfoButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          width: double.infinity,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(secondaryColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            onPressed: state is LoadingUpdateUserState
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      authBloc.add(
                        UpdateProfileEvent(
                          login: _login.text,
                          name: _name.text,
                          surname: _surname.text,
                          phone: _phone.text,
                          email: _email.text,
                          password: _password.text,
                          userId: widget.author.user_id,
                          userToken: userToken,
                          avatar: Provider.of<ImagePickerProvider>(context, listen: false).image,
                        ),
                      );
                    }
                  },
            child: Padding(
              padding: const EdgeInsets.all(17.0),
              child: state is LoadingUpdateUserState
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                  : Text(translations!['update'] ?? 'Update'),
            ),
          ),
        );
      },
    );
  }

  Container _buildDeleteAccount() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.red),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(17.0),
          child: Text(translations!['delete_account'] ?? 'Delete account'),
        ),
        onPressed: () async {
          if (Platform.isIOS) {
            cupertinoAlertDialog(
              context: context,
              title: translations!['quit'] ?? 'Quit',
              content: translations!['are_you_sure_to_delete_account'] ?? 'Are you sure to delete account?',
              submitText: translations?['ok'] ?? 'Ok',
              cancelText: translations?['cancel'] ?? 'Cancel',
              onPressedYes: () {
                carFeatures.clear();
                carData.clear();
                Provider.of<AddCarFunctions>(context, listen: false).addCarMap.clear();
                Provider.of<ImagePickerProvider>(context, listen: false).deleteAllImage();
                preferences.remove('token');
                preferences.remove('userId');
                preferences.remove('password');
                Navigator.pushNamedAndRemoveUntil(context, '/main_screen', ModalRoute.withName('/main_screen'));
              },
              onPressedNo: () => Navigator.of(context).pop(),
            );
          } else {
            materialAlertDialog(
              context: context,
              title: translations!['quit'] ?? 'Quit',
              content: translations!['are_you_sure_to_delete_account'] ?? 'Are you sure to delete account?',
              submitText: translations?['ok'] ?? 'Ok',
              cancelText: translations?['cancel'] ?? 'Cancel',
              onPressedYes: () {
                carFeatures.clear();
                carData.clear();
                Provider.of<AddCarFunctions>(context, listen: false).addCarMap.clear();
                Provider.of<ImagePickerProvider>(context, listen: false).deleteAllImage();
                preferences.remove('token');
                preferences.remove('userId');
                preferences.remove('password');
                Navigator.pushNamedAndRemoveUntil(context, '/main_screen', ModalRoute.withName('/main_screen'));
              },
              onPressedNo: () => Navigator.of(context).pop(),
            );
          }
        },
      ),
    );
  }
}
