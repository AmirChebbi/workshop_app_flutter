class Expense {
  final String? id;
  final String title;
  final double amount;
  final DateTime createdAt;

  const Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    "title": title,
    "amount": amount,
    "createdAt": createdAt.toIso8601String(),
  };

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String?,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class ExpensePage {
  final List<Expense> data;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const ExpensePage({
    required this.data,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory ExpensePage.fromJson(Map<String, dynamic> json) {
    final pagination = json['pagination'];

    return ExpensePage(
      data: (json['data'] as List)
          .map((item) => Expense.fromJson(item))
          .toList(),
      page: pagination['page'],
      limit: pagination['limit'],
      total: pagination['total'],
      totalPages: pagination['totalPages'],
    );
  }
}
