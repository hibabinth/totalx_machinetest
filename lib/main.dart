import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_strings.dart';
import 'presentation/viewmodels/auth_viewmodel.dart';
import 'presentation/viewmodels/user_viewmodel.dart';
import 'presentation/views/auth/login_view.dart';
import 'presentation/views/home/views/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: Colors.white,
        ),
        home: Consumer<AuthViewModel>(
          builder: (context, authViewModel, _) {
            return authViewModel.isLoggedIn
                ? const HomeView()
                : const LoginView();
          },
        ),
      ),
    );
  }
}
