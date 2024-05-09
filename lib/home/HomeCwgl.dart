import 'package:flutter/material.dart';
import 'package:cptapp/sign/SignInPage.dart';
import 'yusuanguanli/ysgl_main.dart';
import 'package:cptapp/classdata.dart';
import 'baobiaoshengcheng/bbsc_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cptapp/cameraclass.dart';

class HomePage extends StatefulWidget {
  final String username;

  HomePage({required this.username});

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  bool _isSearching = false;
  final FocusNode _focusNode = FocusNode();
  int _contentMode = 0;  // 默认模式
  final CameraService _cameraService = CameraService();


  @override
  Widget build(BuildContext context) {
    List<Widget> content = [_buildHeader(widget.username),  // 通用头部
       _buildMenuGrid()   ];
    switch (_contentMode) {
      case 0:
        content.addAll([
          _buildSearchBox(),
          ...mockFinanceData.map((item) => _buildFinanceItem(
            item.title,
            item.context,
            item.amount,
            item.startDate,
            item.endDate,
            item.baoxiao,
          )).toList(),  // 使用扩展运算符...来正确展开列表
        ]);
        break;
      case 1:
        content.addAll([
          _buildLuru()
        ]);
        break;
      case 2:
        content.addAll([
          ...mockFinanceData.map((item) => _buildFinanceItem(
            item.title,
            item.context,
            item.amount,
            item.startDate,
            item.endDate,
            item.baoxiao,
          )).toList(),  // 使用扩展运算符...来正确展开列表
        ]);
        break;
      case 3:
        content.addAll([
          Text('其他页面内容')
        ]);
        break;
    }
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '财务管理',
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
                    '${widget.username}',
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
      body:  ListView(children: content),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: '财务管理',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            // 使用摄像头图标代表 "扫一扫"
            label: '预算管理',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: '报表生成',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '我',
          ),
        ],
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed, // 当有四个以上的项时需要设置为 fixed
        selectedItemColor: Colors.blue, // 设置选中项的颜色
        unselectedItemColor: Colors.black, // 设置未选中项的颜色
        showUnselectedLabels: true, // 是否显示未选中项的标签
        // 此处你可以添加逻辑以处理点击事件
      ),
    );
  }

  Widget _buildSearchBox() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 16), // 控制上下间隔
      child: TextField(
        decoration: InputDecoration(
          labelText: '搜索',  // 显示搜索标签
          hintText: '输入搜索的账单...',  // 提示文本
          prefixIcon: Icon(Icons.search),  // 前置图标
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),  // 边框圆角
          ),
        ),
        onChanged: (value) {
          // 在这里根据输入值进行搜索
        },
      ),
    );
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
  Widget _buildHeader(String username) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 16.0),  // 设置左右边距为16.0
      child: ListTile(
        title: Text(
          'hi ${username}',
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
      padding: EdgeInsets.symmetric(horizontal: 14.0,vertical: 10.0),
      children: <Widget>[
        _buildMenuItem(Icons.receipt, '账单记录',0),
        _buildMenuItem(Icons.edit, '账单录入',1),
        _buildMenuItem(Icons.category, '账单分类',2),
        _buildMenuItem(Icons.bar_chart, '账单统计',3),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String label,int  index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _contentMode = index;  // 根据索引切换模式
        });
      },
      child: Container(
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
            Text(label, style: TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildFinanceItem(String title,String context, int amount, String startDate, String endDate,bool baoxiao) {
    return Container(
        margin:  EdgeInsets.symmetric(horizontal: 20.0,vertical: 8.0),  // 外边距，为容器与其他元素提供间隔
        decoration: BoxDecoration(
          color: Colors.white,  // 背景色
          borderRadius: BorderRadius.circular(16),  // 圆角
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

  Widget _buildLuru() {
    return Container(
      padding: EdgeInsets.all(20),
      margin:EdgeInsets.symmetric(horizontal: 24.0,vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),  // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // 水平方向上居中分布
            children: [
              Spacer(flex: 2,),
              Text("账单录入", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              Spacer(), // 自动扩展的空间，推动后面的元素向右
              Column(
                mainAxisSize: MainAxisSize.min, // 让 Column 紧缩包裹其内容
                children: [
                  IconButton(
                    icon: Icon(Icons.camera_alt), // 使用相机图标
                    iconSize: 30, // 设置图标大小
                    onPressed: () {
                      _cameraService.takePicture();
                    },
                  ),
                  Text("扫描添加", style: TextStyle(fontSize: 12)),
                ],
              ),
              SizedBox(width: 10,), // 确保右边有一定边距
            ],
          ),
          SizedBox(height: 8),
          _buildTextField("名称"),
          _buildTextField("类别"),// 重构的文本输入框
          _buildTextField("日期"),
          _buildTextField("金额"),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: Text("保存"),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,  // 按钮颜色
              onPrimary: Colors.white,  // 文字颜色
              minimumSize: Size(double.infinity, 50), // 按钮大小，宽度充满容器
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildTextField(String label) {
    return Container(
      margin:EdgeInsets.symmetric(horizontal: 30.0,vertical: 4.0),
      padding: EdgeInsets.only(bottom: 10), // 在每个文本输入框下方增加间距
      child: Row(
        children: [
          Expanded(
            flex: 1, // 标签占用可用空间的比例
            child: Text(label+":", style: TextStyle(fontSize: 18, color: Colors.black54)),
          ),
          Expanded(
            flex: 3, // 输入框占用可用空间的比例
            child: TextField(
              style: TextStyle(fontSize: 16, color: Colors.black87), // 设置文本样式
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey), // 提示文本的样式
                border: OutlineInputBorder( // 定义边框
                  borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
                  borderRadius: BorderRadius.circular(8), // 边框圆角
                ),
                enabledBorder: OutlineInputBorder( // 未选中时的边框样式
                  borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder( // 聚焦时的边框样式
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical:16,horizontal: 12),
              ),
            ),

          ),
        ],
      ),
    );
  }

}












