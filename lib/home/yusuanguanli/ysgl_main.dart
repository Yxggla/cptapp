import 'package:flutter/material.dart';
import 'package:cptapp/home/HomeCwgl.dart';
import 'package:dio/dio.dart';
import 'package:cptapp/dio_client.dart';
import 'package:cptapp/providerGL.dart';
import 'package:provider/provider.dart';

class ysgl_mainPage extends StatefulWidget {
  const ysgl_mainPage({Key? key}) : super(key: key);

  @override
  _ysgl_mainPageState createState() => _ysgl_mainPageState();
}

class _ysgl_mainPageState extends State<ysgl_mainPage> {
  String? selectedYear;
  String? selectedYear2;
  String? selectedMonth2;
  final List<String> years =
      List<String>.generate(3, (int index) => (2022 + index).toString());
  final List<String> months = List<String>.generate(
      12, (int index) => (index + 1).toString().padLeft(2, '0'));
  TextEditingController amountController = TextEditingController();
  int moneyYear = 10000;
  int moneyMonth = 1000;
  int _contentMode = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          _buildHeader(),
          _buildSelect(),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_contentMode) {
      case 0:
        return _buildYearYs();
      case 1:
        return _buildMonthYs();
      // case 2:
      //   return ;
      default:
        return Container(); // 默认情况，返回一个空的容器
    }
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
        subtitle: Text('管理你的预算', style: TextStyle(fontSize: 18)),
      ),
    );
  }

  Widget _buildYearYs() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
          child: Row(
            children: [
              Expanded(
                  flex: 4,
                  child: Text(
                    '年度预算：',
                    style: TextStyle(fontSize: 24),
                  )),
              SizedBox(width: 10),
              Expanded(
                flex: 6,
                child: DropdownButtonFormField<String>(
                  value: selectedYear,
                  decoration: InputDecoration(
                    labelText: '年度选择',
                    border: OutlineInputBorder(),
                  ),
                  items: years.map((String year) {
                    return DropdownMenuItem(
                      value: year,
                      child: Text(year),
                    );
                  }).toList(),

                  // 下拉菜单背景颜色
                  borderRadius: BorderRadius.circular(8),
                  // 下拉菜单的圆角
                  onChanged: (value) {
                    setState(() {
                      selectedYear = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),

        _buildLookYS('年'),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '预算:先写死吧$moneyYear',
            style: TextStyle(fontSize: 16),
          ),
        ),
        _buildSQYS('年'),
      ],
    );
  }

  Widget _buildMonthYs() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  '月度预算：',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<String>(
                  value: selectedYear2,
                  decoration: InputDecoration(
                    labelText: '年度选择',
                    border: OutlineInputBorder(),
                  ),
                  items: years.map((String year) {
                    return DropdownMenuItem(
                      value: year,
                      child: Text(year),
                    );
                  }).toList(),
                  borderRadius: BorderRadius.circular(8),
                  onChanged: (value) {
                    setState(() {
                      selectedYear2 = value;
                    });
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<String>(
                  value: selectedMonth2,
                  decoration: InputDecoration(
                    labelText: '月份选择',
                    border: OutlineInputBorder(),
                  ),
                  items: months.map((String month) {
                    return DropdownMenuItem(
                      value: month,
                      child: Text(month),
                    );
                  }).toList(),
                  borderRadius: BorderRadius.circular(8),
                  onChanged: (value) {
                    setState(() {
                      selectedMonth2 = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        _buildLookYS('月'),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '预算:先写死吧$moneyMonth',
            style: TextStyle(fontSize: 16),
          ),
        ),
        _buildSQYS('月'),
      ],
    );
  }

  Widget _buildSelect() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      // 横向间隔
      mainAxisSpacing: 10,
      // 纵向间隔
      childAspectRatio: 1,
      // 调整子元素宽高比
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      children: <Widget>[
        _buildButton('年度预算', Icons.wallet, 0),
        _buildButton('月度预算', Icons.wallet, 1),
        _buildButton('财务跟踪', Icons.wallet, 2),
      ],
    );
  }

  Widget _buildButton(String text, IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _contentMode = index;
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
                size: 24,
                color: _contentMode == index ? Colors.blue : Colors.black),
            // 图标颜色也进行区分
            SizedBox(height: 8),
            Text(text,
                style: TextStyle(
                    fontSize: 16,
                    color: _contentMode == index ? Colors.blue : Colors.black)),
          ],
        ),
      ),
    );
  }


  Widget _buildLookYS(String lable){
    return Padding(
      padding: EdgeInsets.only(left: 45, right: 45, top: 24, bottom: 10),
      child: ElevatedButton(
        onPressed: () {
          // 这里添加按钮点击时的处理逻辑
        },
        child: Text(
          '查询此$lable预算',
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
              EdgeInsets.symmetric(vertical: 16, horizontal: 30)),
          // 调整内边距
          overlayColor: MaterialStateProperty.all(
              Colors.blue.shade700), // 覆盖颜色，提供视觉反馈
        ),
      ),
    );
  }

  Widget _buildSQYS(String lable){
    return Padding(
      padding: EdgeInsets.only(left: 45, right: 45, top: 100, bottom: 10),
      child: ElevatedButton(
        onPressed: () {
          // 这里添加按钮点击时的处理逻辑
        },
        child: Text(
          '申请此$lable预算调整',
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
              EdgeInsets.symmetric(vertical: 16, horizontal: 30)),
          // 调整内边距
          overlayColor: MaterialStateProperty.all(
              Colors.blue.shade700), // 覆盖颜色，提供视觉反馈
        ),
      ),
    );
  }
  void ShowValue(){

  }
}
