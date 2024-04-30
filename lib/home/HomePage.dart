import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String username;

  HomePage({required this.username}); // 添加构造函数参数
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center, // 将内容居中
          children: <Widget>[
            Icon(Icons.home), // 示例图标
            SizedBox(width: 10), // 图标和文本之间的间隔
            Text(
              '$username',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Icon(Icons.menu, color: Colors.grey),
        actions: <Widget>[
          CircleAvatar(
            // backgroundImage: NetworkImage('你的图片链接'), // 这里替换为你的用户头像图片链接
            backgroundColor: Colors.blue,
          ),
          SizedBox(width: 20),
          SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: <Widget>[
                  _buildMenuItem(Icons.account_balance, '财务管理'),
                  _buildMenuItem(Icons.home, '预约管理'),
                  _buildMenuItem(Icons.assignment, '报表生成'),
                  // 添加更多按钮
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.crop_free),
            // 使用摄像头图标代表 "扫一扫"
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        backgroundColor: Colors.blue,
        type: BottomNavigationBarType.fixed, // 当有四个以上的项时需要设置为 fixed
        selectedItemColor: Colors.white, // 设置选中项的颜色
        unselectedItemColor: Colors.white70, // 设置未选中项的颜色
        showUnselectedLabels: true, // 是否显示未选中项的标签
        // 此处你可以添加逻辑以处理点击事件
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label) {
    return Card(
      elevation: 2.0,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 50),
            Text(label),
          ],
        ),
      ),
    );
  }
}
