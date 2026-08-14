import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/expense_model.dart';

class ExpenseRepository {
  final String baseUrl;

  ExpenseRepository({required this.baseUrl});

  Future<ExpensePage> getExpenses({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/api/expenses?page=$page&limit=$limit',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load expenses');
    }

    final json = jsonDecode(response.body);

    return ExpensePage.fromJson(json);
  }

  Future<Expense> createExpense(Expense expense) async {
    final response = await http.post(
      Uri.parse('$baseUrl/expenses'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(expense.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create expense');
    }

    return Expense.fromJson(
      jsonDecode(response.body),
    );
  }

  Future<void> deleteExpense(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/expenses/$id'),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete expense');
    }
  }
}