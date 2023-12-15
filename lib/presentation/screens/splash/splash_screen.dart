import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/presentation/bloc/splash/splash_bloc.dart';
import 'package:motors_app/presentation/screens/screens.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SplashBloc, SplashState>(
        builder: (context, state) {
          return _buildBg(state, context);
        },
      ),
    );
  }

  _buildBg(state, context) {
    if (state is InitialSplashState) {
      return _buildWidgetBg(state);
    }

    if (state is CloseSplashState) {
      if (!state.isSigned) {
        Future.delayed(const Duration(milliseconds: 500), () async {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => SignInScreen(),
            ),
            (Route<dynamic> route) => false,
          );
        });
      } else {
        Future.delayed(const Duration(milliseconds: 500), () async {
          Navigator.pushNamedAndRemoveUntil(
              context, '/main_screen', ModalRoute.withName('/main_screen'));
        });
      }

      return _buildWidgetBg(state.appSettings.numOfListings.toString());
    }

    if (state is ErrorSplashState) {
      return Center(
        child: Text(translations?['error'] ?? 'Error'),
      );
    }
  }

  _buildWidgetBg(state) {
    return Stack(
      children: [
        // Background image
        Hero(
          tag: 'logo',
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/launch_bg.jpg'),
                fit: BoxFit.cover,
                alignment: Alignment(-.6, 0),
              ),
            ),
          ),
        ),
        // Logo Motors
        // Count listings
        Padding(
          padding: const EdgeInsets.only(bottom: 60.0),
          child: SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // if (state is InitialSplashState)
                  //   const SizedBox(
                  //     width: 20,
                  //     height: 20,
                  //     child: LoaderWidget(),
                  //   )
                  // else
                  //   Text(
                  //     state,
                  //     style: const TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 35,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),

                  // const SizedBox(height: 10),
                  // // Text
                  // Text(
                  //   '${translations?['vehicle_for_sale'] ?? 'Vehicle for sale'}',
                  //   style: const TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 15,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
