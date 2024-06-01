import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cptapp/test/test.dart';

// 将这个部分代码复制到您的源文件中，或者确保测试文件可以引入它
Widget _buildStateIcon(int state) {
  Icon icon;
  Color color;
  String text;

  switch (state) {
    case 0:
      icon = Icon(Icons.cancel);
      color = Colors.red;
      text = '未通过';
      break;
    case 1:
      icon = Icon(Icons.check_circle);
      color = Colors.green;
      text = '已报销';
      break;
    case 2:
      icon = Icon(Icons.hourglass_empty);
      color = Colors.orange;
      text = '审核中';
      break;
    default:
      icon = Icon(Icons.error);
      color = Colors.grey;
      text = '未定义';
      break;
  }

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      icon,
      Text(
        text,
        style: TextStyle(color: color, fontSize: 14),
      ),
    ],
  );
}

void main() {
  testWidgets('测试 _buildStateIcon 函数 - 未通过', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: _buildStateIcon(0),
      ),
    ));

    expect(find.byIcon(Icons.cancel), findsOneWidget);
    expect(find.text('未通过'), findsOneWidget);
    expect(find.byType(Text), findsWidgets);
    expect(((tester.firstWidget(find.byType(Text)) as Text).style?.color), Colors.red);
  });

  testWidgets('测试 _buildStateIcon 函数 - 已报销', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: _buildStateIcon(1),
      ),
    ));

    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(find.text('已报销'), findsOneWidget);
    expect(find.byType(Text), findsWidgets);
    expect(((tester.firstWidget(find.byType(Text)) as Text).style?.color), Colors.green);
  });

  testWidgets('测试 _buildStateIcon 函数 - 审核中', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: _buildStateIcon(2),
      ),
    ));

    expect(find.byIcon(Icons.hourglass_empty), findsOneWidget);
    expect(find.text('审核中'), findsOneWidget);
    expect(find.byType(Text), findsWidgets);
    expect(((tester.firstWidget(find.byType(Text)) as Text).style?.color), Colors.orange);
  });
  testWidgets('测试 _buildStateIcon 函数 - 无效状态', (WidgetTester tester) async {
    // 测试无效状态值
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: _buildStateIcon(-1),
      ),
    ));
    // 验证是否回退到默认图标和文本
    expect(find.byIcon(Icons.error), findsOneWidget);
    expect(find.text('未定义'), findsOneWidget);
  });

}