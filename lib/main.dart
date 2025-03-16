import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/auth_controller.dart';
import 'controllers/todo_controller.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/todos_screen.dart';
import 'services/api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final apiService = Get.put(ApiService());
  final authController = Get.put(AuthController());
  final todoController = Get.put(TodoController());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      getPages: [
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/register', page: () => const RegisterScreen()),
        GetPage(name: '/todos', page: () => const TodosScreen()),
      ],
      home: FutureBuilder<bool>(
        future: apiService.hasValidToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasData && snapshot.data!) {
            return const TodosScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
