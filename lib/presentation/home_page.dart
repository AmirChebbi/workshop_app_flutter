import 'package:flutter/material.dart';

import 'add_expense_page.dart';
import 'expense_detail_page.dart';

import '../model/expense_model.dart';
import '../services/expenses.service.dart';

class HomePage extends StatefulWidget {
  final ExpenseService service;

  const HomePage({
    super.key,
    required this.service,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Expense> expenses = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    try {
      final result = await widget.service.getExpenses();

      setState(() {
        expenses = result.data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  double get totalExpenses {
    return widget.service.calculateTotal(expenses);
  }

  Future<void> _openDetail(Expense expense) async {
    final result = await Navigator.of(context).push<ExpenseDetailResult>(
      MaterialPageRoute(
        builder: (_) => ExpenseDetailPage(
          expense: expense,
          service: widget.service,
        ),
      ),
    );

    if (result is ExpenseDeleted) {
      setState(() => expenses.removeWhere((e) => e.id == result.id));
    } else if (result is ExpenseUpdated) {
      setState(() {
        final index = expenses.indexWhere((e) => e.id == result.expense.id);
        if (index != -1) expenses[index] = result.expense;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Expenses'),
      ),

      body: _buildBody(),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.of(context).push<Expense>(
            MaterialPageRoute(
              builder: (_) => AddExpensePage(service: widget.service),
            ),
          );

          if (created != null) {
            setState(() => expenses.insert(0, created));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
            ),

            const SizedBox(height: 16),

            const Text('Something went wrong'),

            const SizedBox(height: 8),

            Text(errorMessage!),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  errorMessage = null;
                });

                loadExpenses();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (expenses.isEmpty) {
      return const Center(
        child: Text(
          'No expenses yet.',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      );
    }

    return Column(
      children: [
        _buildTotalCard(),

        const SizedBox(height: 16),

        Expanded(
          child: ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];

              return _buildExpenseTile(expense);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTotalCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Total Expenses',
              style: TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              '${totalExpenses.toStringAsFixed(2)} TND',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseTile(Expense expense) {
    return ListTile(
      onTap: () => _openDetail(expense),
      leading: const CircleAvatar(
        child: Icon(Icons.money),
      ),

      title: Text(expense.title),

      subtitle: Text(
        expense.createdAt.toLocal().toString(),
      ),

      trailing: Text(
        '${expense.amount.toStringAsFixed(2)} TND',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}