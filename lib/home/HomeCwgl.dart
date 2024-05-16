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
import 'package:dio/dio.dart';
import 'package:cptapp/services/dio_client.dart';
import 'package:cptapp/providerGL.dart';
import 'package:provider/provider.dart';
import 'user/UserPage.dart';
import 'package:cptapp/models/finance_item.dart';
import 'package:cptapp/services/finance_service.dart';
import 'package:cptapp/models/finance_request.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DioClient dioClient;
  late FinanceService financeService;
  bool _isSearching = false;
  bool isLoading = true;
  final FocusNode _focusNode = FocusNode();
  int _contentMode = 0; // 默认模式
  final CameraService _cameraService = CameraService();
  String _currentFilter = '全部'; // Default filter
  List<FinanceItem> financeItems = [];
  TextEditingController _minAmountController = TextEditingController();
  TextEditingController _maxAmountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  List<String> filterOptions = [
    '全部',
    '住宿',
    '餐饮',
    '出行',
    '应酬',
    '采购',
    '团建',
    '电话费'
  ];
  String _selectedReimbursement = '';
  final List<String> _categories = [
    '住宿',
    '餐饮',
    '出行',
    '应酬',
    '采购',
    '团建'
  ]; // 可选的类别列表
  int _selectedIndex_bottom = 0;
  final List<String> _titles = ['财务管理', '预算管理', '报表生成', '我的信息'];
  final List<String> reimbursementOptions = ['全部', '未通过', '已报销', '审核中'];
  String? username;
  DioClient _dioClient = DioClient();
  int? _selectedCategory_lr; //录入时的选择的类别索引
  int? _selectedBXIndex = 0; // 分类中保存选择的是否报销索引
  int? _selectedCategory_fl = 0; //分类中保存选择的类型索引
  FinanceRequest requestALL = FinanceRequest(
    type: null,
    state: null,
    minCost: null,
    maxCost: null,
    pageSize: null,
    pageNum: null,
  );

  //定义类
  FinanceRequest requestSelect = FinanceRequest(
    type: null,
    state: null,
    minCost: null,
    maxCost: null,
    pageSize: null,
    pageNum: null,
  );

  @override
  void dispose() {
    _minAmountController.dispose();
    _maxAmountController.dispose();
    super.dispose();
  }

  void initializeServices() async {
    dioClient = DioClient();
    financeService = FinanceService(dioClient);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserNotifier>(context, listen: false).fetchUsername();
    });
    initializeServices();
    fetchFinanceData(requestALL);
    addListeners();
  }

  void addListeners() {
    _minAmountController
        .addListener(() => updateRequest('minCost', _minAmountController.text));
    _maxAmountController
        .addListener(() => updateRequest('maxCost', _maxAmountController.text));
  }

  void updateRequest(String field, String value) {
    int? intValue = value.isEmpty ? null : int.tryParse(value);
    switch (field) {
      case 'type':
        requestSelect = requestSelect.copyWith(type: intValue);
        break;
      case 'state':
        requestSelect = requestSelect.copyWith(state: intValue);
        break;
      case 'minCost':
        requestSelect = requestSelect.copyWith(minCost: intValue);
        break;
      case 'maxCost':
        requestSelect = requestSelect.copyWith(maxCost: intValue);
        break;
    }
    print("Fetching data with new request: ${requestSelect.toJson()}");
    fetchFinanceData(requestSelect);
  }

  @override
  Widget build(BuildContext context) {
    final username = Provider.of<UserNotifier>(context).username;
    return GestureDetector(
      onTap: () {
        // 调用这个方法后，当前活跃的焦点（这里指的是文本框）会失去焦点，
        // 并关闭软键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
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
                _buildDrawerItem(Icons.settings, '我的信息', context, () {
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
              label: '我的信息',
            ),
          ],
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          // 当有四个以上的项时需要设置为 fixed
          selectedItemColor: Colors.blue,
          // 设置选中项的颜色
          unselectedItemColor: Colors.black,
          // 设置未选中项的颜色
          showUnselectedLabels: true,
          // 是否显示未选中项的标签
          currentIndex: _selectedIndex_bottom,
          onTap: _onItemTapped,
          // 此处你可以添加逻辑以处理点击事件
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex_bottom = index; // 更新选中的索引，并触发页面重建
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

  Widget _buildHeader() {
    final username = Provider.of<UserNotifier>(context).username;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      // 设置左右边距为16.0
      child: ListTile(
        title: Text(
          'hi $username',
          style: TextStyle(fontSize: 60),
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
          handleRefresh();
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

  Widget _buildFinanceItem(String name, String typeString, int cost,
      String formattedCreatedAt, BaoxiaoState state) {
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
            '$name',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('类型: $typeString', style: TextStyle(fontSize: 16)),
              // 注意这里应该显示类型而不是重复标题
              Text('金额: ¥$cost',
                  style: TextStyle(fontSize: 16, color: Colors.green)),
              Text('日期: $formattedCreatedAt',
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                state == 1
                    ? Icons.check_circle
                    : state == 2
                        ? Icons.hourglass_empty
                        : Icons.cancel, // 根据baoxiao变量选择图标
                color: state == 1
                    ? Colors.green
                    : state == 2
                        ? Colors.orange
                        : Colors.red, // 根据baoxiao变量选择颜色
              ),
              Text(
                state == 1
                    ? '已报销'
                    : state == 2
                        ? '审核中'
                        : '未通过', // 根据baoxiao变量选择文本
                style: TextStyle(
                  color: state == 1
                      ? Colors.green
                      : state == 2
                          ? Colors.orange
                          : Colors.red,
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
          _buildTextField("名称", _nameController),
          _buildTextField_LeiBie("类别"), // 重构的文本输入框
          _buildTextField("金额", _amountController),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.only(left: 45, right: 45, top: 10, bottom: 20),
            child: ElevatedButton(
              onPressed: billUpLoad,
              child: Text(
                "上传",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return Colors.blue.shade900; // 按钮被按下时的深蓝色
                    return Colors.blue; // 默认颜色
                  },
                ),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                // 设置文字颜色
                elevation: MaterialStateProperty.all(10),
                // 提升的阴影效果
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0), // 设置按钮的圆角更圆滑
                  side: BorderSide(color: Colors.blue.shade700), // 设置边框颜色稍深
                )),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 16, horizontal: 100)),
                // 调整内边距
                overlayColor: MaterialStateProperty.all(
                    Colors.blue.shade700), // 覆盖颜色，提供视觉反馈
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
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
              controller: controller,
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
                    EdgeInsets.symmetric(vertical: 18, horizontal: 20),
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
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              // 内边距调整
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400, width: 1),
                // 边框颜色和宽度
                borderRadius: BorderRadius.circular(10), // 边框圆角
              ),
              child: DropdownButtonHideUnderline(
                // 隐藏默认的下划线
                child: DropdownButton<int>(
                  value: _selectedCategory_lr,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
                  // 下拉图标和颜色
                  onChanged: (int? newIndex) {
                    setState(() {
                      _selectedCategory_lr = newIndex;
                    });
                  },
                  items: _categories
                      .asMap()
                      .entries
                      .map<DropdownMenuItem<int>>((entry) {
                    int idx = entry.key;
                    String val = entry.value;
                    return DropdownMenuItem<int>(
                      value: idx,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Text(val),
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
        child: DropdownButton<int>(
          value: _selectedCategory_fl,
          icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
          // 下拉图标和颜色
          onChanged: (int? newIndex) {
            setState(() {
              _selectedCategory_fl = newIndex;
            });
            if (_selectedCategory_fl != null) {
              updateRequest('type', (_selectedCategory_fl! - 1).toString());
            }
          },
          items:
              filterOptions.asMap().entries.map<DropdownMenuItem<int>>((entry) {
            int idx = entry.key;
            String val = entry.value;
            return DropdownMenuItem<int>(
              value: idx,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Text(val),
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
    );
  }

  Widget _buildReimbursementFilter() {
    return Container(
      padding: const EdgeInsets.only(left: 26, right: 26.0),
      decoration: BoxDecoration(
        color: Colors.white, // Background color of the dropdown button
        borderRadius: BorderRadius.circular(14), // Rounded corners
        border: Border.all(
            color: Colors.blueAccent, width: 2), // Border color and width
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: _selectedBXIndex,
          icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
          iconSize: 24,
          elevation: 12,
          onChanged: (int? newIndex) {
            setState(() {
              _selectedBXIndex = newIndex;
            });
            if (_selectedBXIndex != null) {
              updateRequest('state', (_selectedBXIndex! - 1).toString());
            }
          },
          items: reimbursementOptions
              .asMap()
              .entries
              .map<DropdownMenuItem<int>>((entry) {
            int idx = entry.key;
            String val = entry.value;
            return DropdownMenuItem<int>(
              value: idx,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Text(val),
              ),
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
              onChanged: null,
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
              onChanged: null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilters_Select() {
    return Container(
      padding: EdgeInsets.all(12), // 增加外边距
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
                          fontSize: 18, // 字体大小
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
                          fontSize: 18, // 字体大小
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
      _buildHeader(), // 通用头部
      _buildMenuGrid()
    ];
    switch (_contentMode) {
      case 0:
        content.addAll([
          _buildSearchBox(),
          ...financeItems
              .map((item) => _buildFinanceItem(
                    item.name,
                    item.typeString,
                    item.cost,
                    item.formattedCreatedAt, // 使用格式化后的日期时间
                    item.state,
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
          ...financeItems
              .map((item) => _buildFinanceItem(
                    item.name,
                    item.typeString,
                    item.cost,
                    item.formattedCreatedAt, // 使用格式化后的日期时间
                    item.state,
                  ))
              .toList(), // 使用扩展运算符...来正确展开列表
        ]);
        break;
    }
    return ListView(children: content);
  }

  Widget _buildSelectedPage_Body() {
    switch (_selectedIndex_bottom) {
      case 0:
        return _buildContentForIndex0();
      case 1:
        return ysgl_mainPage(); // 你提到的另一个页面的Widget
      case 2:
        return bbsc_mainPage(); // 假设是报表生成的页面
      default:
        return UserPagePage();
    }
  }

//账单上传
  void billUpLoad() async {
    String name = _nameController.text;
    int? category = _selectedCategory_lr;
    int amount;
    if (category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('请选择一个类别')),
      );
      return;
    }
    try {
      amount = int.parse(_amountController.text);
      bool success = await _dioClient.billUpLoad(category, amount, name);
      if (success) {
        // 处理上传成功的逻辑
        print('账单上传成功');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('账单上传成功')),
        );
      } else {
        // 处理上传失败的逻辑
        print('账单上传失败');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('账单上传失败')),
        );
      }
    } catch (e) {
      // 处理异常
      print('上传过程中发生异常: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('上传过程中发生异常')),
      );
    }
  }

  //获取账单
  Future<void> fetchFinanceData(FinanceRequest request) async {
    try {
      final List<FinanceItem> fetchedItems =
          await financeService.fetchFinanceData(request);
      setState(() {
        financeItems = fetchedItems;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching finance data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void handleRefresh() {
    if (_contentMode == 0) {
      fetchFinanceData(requestALL);
    }
    if (_contentMode == 2) {
      fetchFinanceData(requestSelect);
    }
  }
}
