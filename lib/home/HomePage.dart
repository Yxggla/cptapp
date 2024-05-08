import 'package:flutter/material.dart';
import 'package:cptapp/sign/SignInPage.dart';
import 'yusuanguanli/ysgl_main.dart';
import 'caiwuguanli/cwgl_main.dart';
import 'baobiaoshengcheng/bbsc_main.dart';
class HomePage extends StatelessWidget {
  final String username;

  HomePage({required this.username}); // 添加构造函数参数
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$username',
              style: TextStyle(color: Colors.black,fontSize:22),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Builder(  // 使用Builder来获得正确的context
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.grey),
            onPressed: () => Scaffold.of(context).openDrawer(), // 现在使用的是正确的context
          ),
        ),
        actions: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.blue,
          ),
          SizedBox(width: 20),
        ],
      ),

    drawer: ClipRRect(
    borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)), // 设置右上和右下角的圆角
      child: Drawer(
        backgroundColor: Colors.blue,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 80, // 设置图片的高度
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("img/MyHomePage/logo1@3x.png"), // 使用 AssetImage
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '$username',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            _buildDrawerItem(Icons.home, '首页', context, () {
              Navigator.pop(context); // 只关闭抽屉
            }),
            _buildDrawerItem(Icons.account_balance, '财务管理', context, () {
              Navigator.pop(context); // 关闭抽屉
            }),
            _buildDrawerItem(Icons.account_balance_wallet, '预算管理', context, () {
              Navigator.pop(context); // 先关闭抽屉
              Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage())); // 然后跳转到预算管理页面
            }),
            _buildDrawerItem(Icons.assignment, '报表生成', context, () {
              Navigator.pop(context); // 先关闭抽屉
              Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage())); // 然后跳转到预算管理页面
            }),
            _buildDrawerItem(Icons.settings, '设置', context, () {
              Navigator.pop(context); // 先关闭抽屉
            }),

            // 添加更多的列表项...
          ],
        ),
      ),

    ),

      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 1,
                childAspectRatio: 2,
                children: <Widget>[
                  _buildMenuItem(Icons.account_balance, '财务管理',() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => cwgl_mainPage(username: username)));}),
                  _buildMenuItem(Icons.account_balance_wallet, '预算管理',() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ysgl_mainPage()));}),
                  _buildMenuItem(Icons.assignment, '报表生成',() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => bbsc_mainPage()));}),
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

  Widget _buildMenuItem(IconData icon, String label,VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2.0,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 60),
              SizedBox(height: 10),
              Text(label, style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildDrawerItem(IconData icon, String title, BuildContext context, VoidCallback onTap) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 10), // 控制上下间隔
    child: ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      onTap: onTap,
      tileColor: Colors.blue,
    ),
  );
}

