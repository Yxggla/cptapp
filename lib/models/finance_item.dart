import 'package:intl/intl.dart';
enum BaoxiaoState {
  unapproved,  // 未通过
  approved,    // 已报销
  pending      // 审核中
}

class FinanceItem {
  final int id;
  final String createdAt;
  final String updatedAt;
  final String deletedAt;
  final String owner;
  final int type;
  final String name;
  final int cost;
  final BaoxiaoState state;

  FinanceItem({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.owner,
    required this.type,
    required this.name,
    required this.cost,
    required this.state,
  });

  // fromJson 方法
  factory FinanceItem.fromJson(Map<String, dynamic> json) {
    return FinanceItem(
      id: json['id'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      deletedAt: json['deletedAt'] ?? '',
      owner: json['owner'] ?? '',
      type: json['type'] ?? 0,
      name: json['name']  ?? '',
      cost: json['cost'] ?? 0,
      state: _baoxiaoStateFromInt(json['state']),
    );
  }

  // 将整数转换为枚举类型
  static BaoxiaoState _baoxiaoStateFromInt(int state) {
    switch (state) {
      case 0:
        return BaoxiaoState.unapproved;
      case 1:
        return BaoxiaoState.approved;
      case 2:
        return BaoxiaoState.pending;
      default:
        throw ArgumentError('Unknown baoxiao state: $state');
    }
  }

  String get typeString => _typeToString(type);

  // 将整数类型转换为字符串表示
  static String _typeToString(int type) {
    const typeMap = {
      0: '住宿',
      1: '餐饮',
      2: '出行',
      3: '应酬',
      4: '采购',
      5: '团建',
    };
    return typeMap[type] ?? '未知';
  }
  String get formattedCreatedAt {
    try {
      // 解析为DateTime对象
      final DateTime dateTime = DateTime.parse(createdAt);
      // 加上8小时
      final DateTime dateTimeInBeijing = dateTime.add(Duration(hours: 8));
      // 格式化输出
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTimeInBeijing);
    } catch (e) {
      // 如果解析失败，返回原始字符串
      return createdAt;
    }
  }

}