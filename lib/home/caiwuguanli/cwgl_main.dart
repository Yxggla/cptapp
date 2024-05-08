import 'package:flutter/material.dart';
import 'package:cptapp/setdata.dart';

void main() {
  runApp(MaterialApp(home: cwgl_mainPage(username: 'user')));
}

class cwgl_mainPage extends StatefulWidget {
  final String username; // 参数

  cwgl_mainPage({Key? key, required this.username}) : super(key: key);

  @override
  _cwgl_mainPageState createState() => _cwgl_mainPageState();
}

class _cwgl_mainPageState extends State<cwgl_mainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('财务管理', style: TextStyle(color: Colors.black, fontSize: 22)),
      ),
      body: ListView(
        children: <Widget>[
          _buildHeader(),
          _buildMenuGrid(),
          _buildFinanceItem('飞机票','交通', 1000, '2024-1-2', '2024-3',true),
          _buildFinanceItem('飞机票','交通', 1000, '2024-1-2', '2024-3',false),
          _buildFinanceItem('飞机票','住宿', 1000, '2024-1-2', '2024-3',true),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 16.0),  // 设置左右边距为16.0
      child: ListTile(
        title: Text(
          'hi ${widget.username}',
          style: TextStyle(fontSize: 50),
        ),
        subtitle: Text('管理你的账单',style: TextStyle(fontSize: 18)),
      ),
    );
  }


  Widget _buildMenuGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 10, // 横向间隔
      mainAxisSpacing: 10, // 纵向间隔
      childAspectRatio: 1, // 调整子元素宽高比
      padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
      children: <Widget>[
        _buildMenuItem(Icons.edit, '账单录入'),
        _buildMenuItem(Icons.category, '账单分类'),
        _buildMenuItem(Icons.search, '账单查询'),
        _buildMenuItem(Icons.bar_chart, '账单统计'),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.all(16),// 设置内部边距
      decoration: BoxDecoration(
        color: Colors.white,  // 设置背景色，可以根据你的需要进行更改
        borderRadius: BorderRadius.circular(20),  // 设置圆角
        boxShadow: [  // 可选，添加阴影效果
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 3),  // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 28),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }


  Widget _buildFinanceItem(String title,String context, int amount, String startDate, String endDate,bool baoxiao) {
    return Container(
      margin:  EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),  // 外边距，为容器与其他元素提供间隔
      decoration: BoxDecoration(
        color: Colors.white,  // 背景色
        borderRadius: BorderRadius.circular(10),  // 圆角
        boxShadow: [  // 阴影效果
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),  // 阴影颜色
            spreadRadius: 2,  // 阴影扩展程度
            blurRadius: 4,  // 模糊值
            offset: Offset(0, 2),  // X,Y轴偏移
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(Icons.receipt, color: Colors.blue, size: 30),
        title: Text(
          '$title',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('类型: $context', style: TextStyle(fontSize: 16)),  // 注意这里应该显示类型而不是重复标题
            Text('金额: ¥$amount', style: TextStyle(fontSize: 16, color: Colors.green)),
            Text('日期: $startDate - $endDate', style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              baoxiao ? Icons.check_circle : Icons.cancel,  // 根据baoxiao变量选择图标
              color: baoxiao ? Colors.green : Colors.red,  // 根据baoxiao变量选择颜色
            ),
            Text(
              baoxiao ? '已报销' : '未报销',  // 根据baoxiao变量选择文本
              style: TextStyle(
                color: baoxiao ? Colors.green : Colors.red,  // 根据baoxiao变量选择文本颜色
                fontSize: 14,
              ),
            ),
          ],
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        onTap: () {
          // 点击事件
        },
      )

    );
  }

}
