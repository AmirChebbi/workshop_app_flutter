import 'package:flutter/material.dart';
import 'package:workshop_app/presentation/welcome_page.dart';
import 'package:workshop_app/repository/expenses.repository.dart';
import 'package:workshop_app/services/expenses.service.dart';

void main() {
  final repository = ExpenseRepository(
    baseUrl: 'https://workshop-app-backend.vercel.app',
  );

  final service = ExpenseService(
    repository: repository,
  );

  runApp(
    MyApp(
      service: service,
    ),
  );
}

class MyApp extends StatelessWidget {
  final ExpenseService service;

  const MyApp({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workshop App',
      home: WelcomePage(
        service: service,
      ),
    );
  }
}