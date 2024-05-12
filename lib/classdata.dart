class FinanceItem {
  final String title;
  final String context;
  final int amount;
  final String Date;
  final bool baoxiao;

  FinanceItem({
    required this.title,
    required this.context,
    required this.amount,
    required this.Date,
    required this.baoxiao
  });
}

List<FinanceItem> mockFinanceData = [
  FinanceItem(title: '飞机票', context: '交通', amount: 1000, Date: '2024-3', baoxiao: true),
  FinanceItem(title: '火车票', context: '交通', amount: 800, Date: '2024-3', baoxiao: false),
  FinanceItem(title: '酒店费', context: '住宿', amount: 1500, Date: '2024-3', baoxiao: true),
  FinanceItem(title: '请老板吃饭钱', context: '餐饮', amount: 8500, Date: '2024-4', baoxiao: true),
  FinanceItem(title: '报销的电话费', context: '电话费', amount: 200, Date: '2024-3', baoxiao: false),
];

class UserItem{
  final String username;
  final String phone;

  UserItem({
    required this.username,
    required this.phone,
  });
}


