import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_screen_homework/screens/router.dart';
import 'package:login_screen_homework/utils/colors/colors.dart';
import 'package:login_screen_homework/utils/constanst/constants.dart';
import 'package:login_screen_homework/utils/style/style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: UzchatColors.colorScaffold,
        appBarTheme: const AppBarTheme(
          color: UzchatColors.colorScaffold,
          elevation: 1,
          iconTheme: IconThemeData(
            color: UzchatColors.colorBlack,
          ),
          titleTextStyle: UzchatStyle.w600,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: UzchatColors.colorScaffold,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
      ),
      onGenerateRoute: Routers.generateRoute,
      initialRoute: Constants.splashScreen,
    );
  }
}
