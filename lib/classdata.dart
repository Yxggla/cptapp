class FinanceItem {
  final String title;
  final String context;
  final int amount;
  final String startDate;
  final String endDate;
  final bool baoxiao;

  FinanceItem({
    required this.title,
    required this.context,
    required this.amount,
    required this.startDate,
    required this.endDate,
    required this.baoxiao
  });
}

List<FinanceItem> mockFinanceData = [
  FinanceItem(title: '飞机票', context: '交通', amount: 1000, startDate: '2024-1-2', endDate: '2024-3', baoxiao: true),
  FinanceItem(title: '火车票', context: '交通', amount: 800, startDate: '2024-1-5', endDate: '2024-3', baoxiao: false),
  FinanceItem(title: '酒店费', context: '住宿', amount: 1500, startDate: '2024-1-3', endDate: '2024-3', baoxiao: true),
];