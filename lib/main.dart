import 'package:device_preview/device_preview.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/shared_components/components.dart';
import 'package:motors_app/core/styles/app_theme.dart';
import 'package:motors_app/core/utils/location_permission.dart';
import 'package:motors_app/data/models/hive/brands.dart';
import 'package:motors_app/data/repositories/auth_repository_impl.dart';
import 'package:motors_app/data/repositories/car_detail_repository_impl.dart';
import 'package:motors_app/data/repositories/filter_repository_impl.dart';
import 'package:motors_app/data/repositories/main_page_repository_impl.dart';
import 'package:motors_app/firebase_api.dart';
import 'package:motors_app/firebase_options.dart';
import 'package:motors_app/presentation/bloc/add_car/add_car_bloc.dart';
import 'package:motors_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:motors_app/presentation/bloc/car_detail/car_detail_bloc.dart';
import 'package:motors_app/presentation/bloc/dealer_profile/dealer_profile_bloc.dart';
import 'package:motors_app/presentation/bloc/filter/filter_bloc.dart';
import 'package:motors_app/presentation/bloc/filter_result/filter_result_bloc.dart';
import 'package:motors_app/presentation/bloc/home/home_bloc.dart';
import 'package:motors_app/presentation/bloc/home/home_event.dart';
import 'package:motors_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:motors_app/presentation/bloc/splash/splash_bloc.dart';
import 'package:motors_app/presentation/screens/screens.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Future<AppSettings>
getAppSettings() async {
  try {
    // print('getting App Settings');
    // final response =
    //     await DioSingleton().instance().get('$apiEndPoint/settings');
    // logo = response.data['logo'];
    logo =
        'https://osmaniamotors.com/wp-content/uploads/2023/06/Osmania-Motors.png';
    print('got $logo');
    // return AppSettings.fromJson(response.data);
  } on DioException catch (e) {
    throw Exception(e.response);
  }
}

late Box<Brand> brandsBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('firebase ');
  await Firebase.initializeApp(
    // name: 'dev-project',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('firebase initialized');
  await Hive.initFlutter();
  Hive.registerAdapter(BrandAdapter());
  brandsBox = await Hive.openBox('brandsBox');
  // Duration(microseconds: 100);
  LocationPermissionImpl locationPermissionImpl = LocationPermissionImpl();
  // Duration(microseconds: 100);

  // Duration(microseconds: 100);

  await locationPermissionImpl.requstLocationPermission();
  preferences = await SharedPreferences.getInstance();
// set city in shared preferences
  String? city = await locationPermissionImpl.getCurrentCity();
  // print('City: $city');
  preferences.setString('city', city ?? '');

  getAppSettings().then(
    (value) => runApp(
      MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // getAppSettings();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SplashBloc>(
            create: (BuildContext context) =>
                SplashBloc()..add(CheckAuthSplashEvent()),
          ),
          BlocProvider<HomeBloc>(
            create: (BuildContext context) =>
                HomeBloc(MainPageRepositoryImpl(), FilterRepositoryImpl())
                  ..add(HomeLoadEvent()),
          ),
          BlocProvider<CarDetailBloc>(
            create: (BuildContext context) =>
                CarDetailBloc(CarDetailRepositoryImpl()),
          ),
          BlocProvider<AuthBloc>(
            create: (BuildContext context) => AuthBloc(AuthRepositoryImpl()),
          ),
          BlocProvider<ProfileBloc>(
            create: (BuildContext context) => ProfileBloc(AuthRepositoryImpl()),
          ),
          BlocProvider<DealerProfileBloc>(
            create: (BuildContext context) =>
                DealerProfileBloc(CarDetailRepositoryImpl()),
          ),
          BlocProvider<FilterBloc>(
            create: (BuildContext context) => FilterBloc(
              FilterRepositoryImpl(),
              CarDetailRepositoryImpl(),
            ),
          ),
          BlocProvider<FilterResultBloc>(
            create: (BuildContext context) => FilterResultBloc(
              FilterRepositoryImpl(),
              LocationPermissionImpl(),
            ),
          ),
          BlocProvider<AddCarBloc>(
            create: (BuildContext context) => AddCarBloc(),
          ),
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<ImagePickerProvider>(
              create: (context) => ImagePickerProvider(),
            ),
            ChangeNotifierProvider<AddCarFunctions>(
              create: (context) => AddCarFunctions(),
            ),
            ChangeNotifierProvider<LocationService>(
              create: (context) => LocationService(),
            ),
            ChangeNotifierProvider<ToggleObscure>(
              create: (context) => ToggleObscure(),
            ),
            ChangeNotifierProvider<ToggleFavouriteProvider>(
              create: (context) => ToggleFavouriteProvider(),
            ),
            ChangeNotifierProvider<ImageSliderProvider>(
              create: (context) => ImageSliderProvider(),
            ),
            ChangeNotifierProvider<ExpansionPanelProvider>(
              create: (context) => ExpansionPanelProvider(),
            ),
            ChangeNotifierProvider<SearchFilterProvider>(
              create: (context) => SearchFilterProvider(),
            ),
          ],
          child: MaterialApp(
            useInheritedMediaQuery: true,
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            title: 'Motors App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme().themeLight,
            scrollBehavior: ScrollBehavior().copyWith(overscroll: false),
            routes: {
              '/': (context) => const SplashScreen(),
              '/main_screen': (context) => const MainScreen(),
              '/home_screen': (context) => HomeScreen(),
              '/add_car_screen': (context) => AddCarScreen(),
              '/search_screen': (context) => const SearchScreen(),
              '/profile_screen': (context) => const ProfileScreen(),
              '/stepTwoScreen': (context) => const StepTwoScreen(),
            },
          ),
        ),
      ),
    );
  }
}

class CustomError extends StatelessWidget {
  CustomError({
    Key? key,
    required this.errorDetails,
  }) : super(key: key);
  final FlutterErrorDetails errorDetails;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        child: Text(
          errorDetails.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        padding: const EdgeInsets.all(8.0),
      ),
      color: Colors.red,
      margin: EdgeInsets.zero,
    );
  }
}
