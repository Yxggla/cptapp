import 'package:flutter/material.dart';
import 'package:cptapp/home/HomeCwgl.dart';

class ysgl_mainPage extends StatefulWidget {
  const ysgl_mainPage({Key? key}) : super(key: key);

  @override
  _ysgl_mainPageState createState() => _ysgl_mainPageState();
}

class _ysgl_mainPageState extends State<ysgl_mainPage> {
  String? selectedYear;
  String? selectedYear2;
  String? selectedMonth2;
  final List<String> years = List<String>.generate(3, (int index) => (2022 + index).toString());
  final List<String> months = List<String>.generate(12, (int index) => (index + 1).toString().padLeft(2, '0'));
  TextEditingController amountController = TextEditingController();
  int moneyyear=10000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          _buildHeader(),
          _buildYS(),
        ],
      ),
         // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      // 设置左右边距为16.0
      child: ListTile(
        title: Text(
          'hi 写死先',
          style: TextStyle(fontSize: 50),
        ),
        subtitle: Text('管理你的预算', style: TextStyle(fontSize: 18)),
      ),
    );
  }
  Widget _buildYS() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 使用 MainAxisAlignment 来调整子部件之间的间距
            children: [
              Text(
                '财务预算',
                style: TextStyle(fontSize: 28),
              ),
              ElevatedButton(
                onPressed: () {
                  // 在这里添加按钮的功能
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue), // 设置按钮背景色
                  foregroundColor: MaterialStateProperty.all(Colors.white), // 设置文字颜色
                  elevation: MaterialStateProperty.all(8), // 设置阴影
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0), // 设置按钮的圆角
                        side: BorderSide(color: Colors.blue), // 设置边框颜色
                      )
                  ),
                  padding: MaterialStateProperty.all(EdgeInsets.all(10)), // 设置内边距
                ),
                child: Text(
                  '财务跟踪',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),

          SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Text('年度预算：',style: TextStyle(fontSize: 24),)
              ),
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
          SizedBox(height: 20),
          Text('预算:先写死吧$moneyyear',style: TextStyle(fontSize: 28),),
          SizedBox(height: 50),
          Row(
            children: [
              Expanded(
                  flex: 4,
                  child: Text('月度预算：',style: TextStyle(fontSize: 24),)
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
          SizedBox(height: 20),
          Text('预算:先写死吧$moneyyear',style: TextStyle(fontSize: 28),),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // 在这里添加按钮点击后的行为
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue), // 设置按钮背景色
              foregroundColor: MaterialStateProperty.all(Colors.white), // 设置文字颜色
              elevation: MaterialStateProperty.all(8), // 设置阴影
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0), // 设置按钮的圆角
                    side: BorderSide(color: Colors.blue), // 设置边框颜色
                  )
              ),
              padding: MaterialStateProperty.all(EdgeInsets.all(16)), // 设置内边距
            ),
            child: Text('申请预算调整',style: TextStyle(fontSize: 22),),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

}
