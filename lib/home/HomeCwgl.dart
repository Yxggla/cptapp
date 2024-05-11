import 'package:flutter/material.dart';
import 'package:cptapp/sign/SignInPage.dart';
import 'yusuanguanli/ysgl_main.dart';
import 'package:cptapp/classdata.dart';
import 'baobiaoshengcheng/bbsc_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cptapp/cameraclass.dart';
import 'yusuanguanli/ysgl_main.dart';
import 'yusuanguanli/ysgl_main_admin.dart';
import 'baobiaoshengcheng/bbsc_main.dart';

class HomePage extends StatefulWidget {
  final String username;

  HomePage({required this.username});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSearching = false;
  final FocusNode _focusNode = FocusNode();
  int _contentMode = 0; // 默认模式
  final CameraService _cameraService = CameraService();
  String _currentFilter = '全部'; // Default filter
  List<FinanceItem> _filteredFinanceData = []; // List to hold filtered data
  double _currentMinAmount = 0.0;
  double _currentMaxAmount = 10000.0; // You can set this based on your data
  TextEditingController _minAmountController = TextEditingController();
  TextEditingController _maxAmountController = TextEditingController();
  List<String> filterOptions = [];
  String _selectedReimbursement = '全部';
  String? _selectedCategory_lr; // 当前选中的类别
  final List<String> _categories = ['类别1', '类别2', '类别3', '类别4']; // 可选的类别列表
  int _selectedIndex_bottom = 0;
  final List<String> _titles = ['财务管理', '预算管理', '报表生成', '我的信息'];

  @override
  void initState() {
    super.initState();
    _filterFinanceData2(); // Initial filter setup
    filterOptions = generateFilterOptions(mockFinanceData);
  }

  List<String> generateFilterOptions(List<FinanceItem> data) {
    var uniqueContexts = data.map((item) => item.context).toSet();// 使用 Set 来获取所有独特的 context 值
    // 将 Set 转换为 List，并添加一个 '全部' 选项
    return ['全部', ...uniqueContexts];
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _titles[_selectedIndex_bottom],
              style: TextStyle(color: Colors.black, fontSize: 22),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Builder(
          // 使用Builder来获得正确的context
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.grey),
            onPressed: () =>
                Scaffold.of(context).openDrawer(), // 现在使用的是正确的context
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
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
        // 设置右上和右下角的圆角
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
                          image: AssetImage(
                              "img/MyHomePage/logo1@3x.png"), // 使用 AssetImage
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
              _buildDrawerItem(Icons.account_balance, '财务管理', context, () {
                Navigator.pop(context); // 先关闭抽屉
              }),
              _buildDrawerItem(Icons.account_balance_wallet, '预算管理', context,
                  () {
                Navigator.pop(context); // 先关闭抽屉
                _onItemTapped(1);
              }),
              _buildDrawerItem(Icons.assignment, '报表生成', context, () {
                Navigator.pop(context); // 先关闭抽屉
                _onItemTapped(2); // 然后跳转到预算管理页面
              }),
              _buildDrawerItem(Icons.settings, '设置', context, () {
                Navigator.pop(context); // 先关闭抽屉
                _onItemTapped(3);
              }),

              // 添加更多的列表项...
            ],
          ),
        ),
      ),
      body: _buildSelectedPage_Body(),
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
        type: BottomNavigationBarType.fixed,
        // 当有四个以上的项时需要设置为 fixed
        selectedItemColor: Colors.blue,
        // 设置选中项的颜色
        unselectedItemColor: Colors.black,
        // 设置未选中项的颜色
        showUnselectedLabels: true, // 是否显示未选中项的标签
        currentIndex: _selectedIndex_bottom,
        onTap: _onItemTapped,
        // 此处你可以添加逻辑以处理点击事件
      ),
    );
  }



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex_bottom = index;  // 更新选中的索引，并触发页面重建
    });
  }

  Widget _buildSearchBox() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16), // 控制上下间隔
      child: TextField(
        decoration: InputDecoration(
          labelText: '搜索', // 显示搜索标签
          hintText: '输入搜索的账单...', // 提示文本
          prefixIcon: Icon(Icons.search), // 前置图标
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0), // 边框圆角
          ),
        ),
        onChanged: (value) {
          // 在这里根据输入值进行搜索
        },
      ),
    );
  }

  Widget _buildDrawerItem(
      IconData icon, String title, BuildContext context, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10), // 控制上下间隔
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
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      // 设置左右边距为16.0
      child: ListTile(
        title: Text(
          'hi ${username}',
          style: TextStyle(fontSize: 50),
        ),
        subtitle: Text('管理你的账单', style: TextStyle(fontSize: 18)),
      ),
    );
  }

  Widget _buildMenuGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 20,
      // 横向间隔
      mainAxisSpacing: 10,
      // 纵向间隔
      childAspectRatio: 1.1,
      // 调整子元素宽高比
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      children: <Widget>[
        _buildMenuItem(Icons.receipt, '账单记录', 0),
        _buildMenuItem(Icons.edit, '账单录入', 1),
        _buildMenuItem(Icons.category, '账单分类', 2),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _contentMode = index; // 根据索引切换模式
        });
      },
      child: Container(
        padding: EdgeInsets.all(22), // 设置内部边距
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20), // 设置圆角
          boxShadow: [
            // 可选，添加阴影效果
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 6,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon,
                size: 30,
                color: _contentMode == index ? Colors.blue : Colors.black),
            // 图标颜色也进行区分
            SizedBox(height: 8),
            Text(label,
                style: TextStyle(
                    fontSize: 14,
                    color: _contentMode == index ? Colors.blue : Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget _buildFinanceItem(
      String title, String context, int amount, String Date, bool baoxiao) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        // 外边距，为容器与其他元素提供间隔
        decoration: BoxDecoration(
          color: Colors.white, // 背景色
          borderRadius: BorderRadius.circular(16), // 圆角
          boxShadow: [
            // 阴影效果
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // 阴影颜色
              spreadRadius: 2, // 阴影扩展程度
              blurRadius: 4, // 模糊值
              offset: Offset(0, 2), // X,Y轴偏移
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
              Text('类型: $context', style: TextStyle(fontSize: 16)),
              // 注意这里应该显示类型而不是重复标题
              Text('金额: ¥$amount',
                  style: TextStyle(fontSize: 16, color: Colors.green)),
              Text('日期: $Date',
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                baoxiao ? Icons.check_circle : Icons.cancel, // 根据baoxiao变量选择图标
                color: baoxiao ? Colors.green : Colors.red, // 根据baoxiao变量选择颜色
              ),
              Text(
                baoxiao ? '已报销' : '未报销', // 根据baoxiao变量选择文本
                style: TextStyle(
                  color: baoxiao ? Colors.green : Colors.red,
                  // 根据baoxiao变量选择文本颜色
                  fontSize: 14,
                ),
              ),
            ],
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          onTap: () {
            // 点击事件
          },
        ));
  }

  Widget _buildLuru() {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // 水平方向上居中分布
            children: [
              Spacer(
                flex: 2,
              ),
              Text("账单录入",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
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
              SizedBox(
                width: 10,
              ), // 确保右边有一定边距
            ],
          ),
          SizedBox(height: 8),
          _buildTextField("名称"),
          _buildTextField_LeiBie("类别"), // 重构的文本输入框
          _buildTextField("金额"),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: Text("保存"),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue, // 按钮颜色
              onPrimary: Colors.white, // 文字颜色
              minimumSize: Size(double.infinity, 50), // 按钮大小，宽度充满容器
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4.0),
      padding: EdgeInsets.only(bottom: 10), // 在每个文本输入框下方增加间距
      child: Row(
        children: [
          Expanded(
            flex: 1, // 标签占用可用空间的比例
            child: Text(label + ":",
                style: TextStyle(fontSize: 18, color: Colors.black54)),
          ),
          Expanded(
            flex: 3, // 输入框占用可用空间的比例
            child: TextField(
              style: TextStyle(fontSize: 16, color: Colors.black87), // 设置文本样式
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey),
                // 提示文本的样式
                border: OutlineInputBorder(
                  // 定义边框
                  borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
                  borderRadius: BorderRadius.circular(8), // 边框圆角
                ),
                enabledBorder: OutlineInputBorder(
                  // 未选中时的边框样式
                  borderSide:
                      BorderSide(color: Colors.grey.shade400, width: 1.0),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  // 聚焦时的边框样式
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField_LeiBie(String label) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4.0),
      padding: EdgeInsets.only(bottom: 10), // 在每个文本输入框下方增加间距
      child: Row(
        children: [
          Expanded(
            flex: 1, // 标签占用可用空间的比例
            child: Text(label + ":",
                style: TextStyle(fontSize: 18, color: Colors.black54)),
          ),
          Expanded(
            flex: 3, // 输入框占用可用空间的比例
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              // 内边距调整
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400, width: 1),
                // 边框颜色和宽度
                borderRadius: BorderRadius.circular(10), // 边框圆角
              ),
              child: DropdownButtonHideUnderline(
                // 隐藏默认的下划线
                child: DropdownButton<String>(
                  value: _selectedCategory_lr,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
                  // 下拉图标和颜色
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory_lr = newValue;
                    });
                  },
                  items:
                      _categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10), // 文本容器的内边距
                        decoration: BoxDecoration(
                          color: Colors.white, // 菜单项背景色
                        ),
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                  dropdownColor: Colors.white,
                  // 下拉菜单背景颜色
                  borderRadius: BorderRadius.circular(16),
                  // 下拉菜单的圆角
                  elevation: 5,
                  // 下拉菜单阴影的高度
                  style: TextStyle(color: Colors.black87, fontSize: 16), // 文本样式
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Container(
      padding: const EdgeInsets.only(left: 26, right: 26.0),
      decoration: BoxDecoration(
        color: Colors.white, // Background color of the dropdown button
        borderRadius: BorderRadius.circular(14), // Rounded corners
        border: Border.all(
            color: Colors.blueAccent, width: 2), // Border color and width
      ),
      child: DropdownButtonHideUnderline(
        // Hide the default underline of a dropdown
        child: DropdownButton<String>(
          value: _currentFilter,
          icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
          iconSize: 24,
          elevation: 12,
          style: TextStyle(color: Colors.blue, fontSize: 16),
          onChanged: (String? newValue) {
            setState(() {
              _currentFilter = newValue!;
              _filterFinanceData2();
            });
          },
          items: filterOptions.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          dropdownColor: Colors.white, // Dropdown menu background color
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildReimbursementFilter() {
    List<String> reimbursementOptions = ['全部', '已报销', '未报销'];
    return Container(
      padding: const EdgeInsets.only(left: 26, right: 26.0),
      decoration: BoxDecoration(
        color: Colors.white, // Background color of the dropdown button
        borderRadius: BorderRadius.circular(14), // Rounded corners
        border: Border.all(
            color: Colors.blueAccent, width: 2), // Border color and width
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedReimbursement,
          icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
          iconSize: 24,
          elevation: 12,
          style: TextStyle(color: Colors.blue, fontSize: 16),
          onChanged: (String? newValue) {
            setState(() {
              _selectedReimbursement = newValue!;
              _filterFinanceData2(); // 更新筛选逻辑
            });
          },
          items: reimbursementOptions
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          borderRadius: BorderRadius.circular(16),
          dropdownColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildAmountFilter() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextField(
              controller: _minAmountController,
              decoration: InputDecoration(
                labelText: '最小金额',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0),
                ),
                suffixText: '元',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 14),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _filterFinanceData2(); // Optionally update filter upon each edit
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextField(
              controller: _maxAmountController,
              decoration: InputDecoration(
                labelText: '最大金额',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0),
                ),
                suffixText: '元',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 14),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _filterFinanceData2(); // Optionally update filter upon each edit
              },
            ),
          ),
        ),
      ],
    );
  }

  void _filterFinanceData2() {
    double minAmount = double.tryParse(_minAmountController.text) ?? 0;
    double maxAmount =
        double.tryParse(_maxAmountController.text) ?? double.infinity;

    _filteredFinanceData = mockFinanceData.where((item) {
      bool matchesType =
          _currentFilter == '全部' || item.context == _currentFilter;
      bool matchesAmount = item.amount >= minAmount && item.amount <= maxAmount;
      bool matchesReimbursement = true; // 默认为 true，适用于 '全部' 选项

      if (_selectedReimbursement == '已报销') {
        matchesReimbursement = item.baoxiao == true;
      } else if (_selectedReimbursement == '未报销') {
        matchesReimbursement = item.baoxiao == false;
      }

      return matchesType && matchesAmount && matchesReimbursement;
    }).toList();

    setState(() {});
  }

  Widget _buildFilters_Select() {
    return Container(
      padding: EdgeInsets.all(10), // 增加外边距
      child: Column(
        // 纵向布局，将两个部分分开
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start, // 使 Row 中的内容居中对齐
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 18, bottom: 5),
                      child: Text(
                        '类型', // 标签文本
                        style: TextStyle(
                          fontSize: 16, // 字体大小
                          fontWeight: FontWeight.bold, // 字体加粗
                          color: Colors.black, // 字体颜色
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4), // 调整下拉框的内边距
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _buildFilterDropdown(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // 垂直居中对齐
                  crossAxisAlignment: CrossAxisAlignment.start, // 文本保持左对齐
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 5),
                      child: Text(
                        '是否报销', // 标签文本
                        style: TextStyle(
                          fontSize: 16, // 字体大小
                          fontWeight: FontWeight.bold, // 字体加粗
                          color: Colors.black, // 字体颜色
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 0), // 调整下拉框的内边距
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _buildReimbursementFilter(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 4, right: 4),
            // 为下一个元素提供顶部间距
            child: _buildAmountFilter(), // 第二行，单独的元素
          ),
        ],
      ),
    );
  }

  Widget _buildContentForIndex0() {
    List<Widget> content = [
      _buildHeader(widget.username), // 通用头部
      _buildMenuGrid()
    ];
    switch (_contentMode) {
      case 0:
        content.addAll([
          _buildSearchBox(),
          ...mockFinanceData
              .map((item) =>
              _buildFinanceItem(
                item.title,
                item.context,
                item.amount,
                item.Date,
                item.baoxiao,
              ))
              .toList(), // 使用扩展运算符...来正确展开列表
        ]);
        break;
      case 1:
        content.addAll([_buildLuru()]);
        break;
      case 2:
        content.addAll([
          _buildFilters_Select(),
          ..._filteredFinanceData
              .map((item) =>
              _buildFinanceItem(
                item.title,
                item.context,
                item.amount,
                item.Date,
                item.baoxiao,
              ))
              .toList(),
        ]);
        break;
    }
    return ListView(children: content);
  }

  Widget _buildSelectedPage_Body()
  {
    switch (_selectedIndex_bottom) {
      case 0:
        return _buildContentForIndex0();
      case 1:
        return ysgl_mainPage();  // 你提到的另一个页面的Widget
      case 2:
        return bbsc_mainPage();  // 假设是报表生成的页面
      default:
        return Center(child: Text("页面未定义"));
    }
  }



}
