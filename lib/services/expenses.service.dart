import '../model/expense_model.dart';
import '../repository/expenses.repository.dart';

class ExpenseService {
  final ExpenseRepository repository;

  ExpenseService({required this.repository});

  Future<ExpensePage> getExpenses() {
    return repository.getExpenses();
  }

  Future<Expense> createExpense(Expense expense) {
    if (expense.amount <= 0) {
      throw Exception('Amount must be greater than zero');
    }

    if (expense.title.trim().isEmpty) {
      throw Exception('Title cannot be empty');
    }

    return repository.createExpense(expense);
  }

  Future<void> deleteExpense(String id) {
    return repository.deleteExpense(id);
  }

  double calculateTotal(List<Expense> expenses) {
    return expenses.fold(
      0,
          (total, expense) => total + expense.amount,
    );
  }
}