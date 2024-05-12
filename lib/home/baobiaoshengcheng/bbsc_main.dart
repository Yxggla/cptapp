import 'package:flutter/material.dart';

/**
 * @author[dongbaba]
 * @version[创建日期，2024/5/8 15:36]
 * @function[功能简介 ]
 **/
class bbsc_mainPage extends StatefulWidget {
  const bbsc_mainPage({Key? key}) : super(key: key);

  @override
  _bbsc_mainPageState createState() => _bbsc_mainPageState();
}

class _bbsc_mainPageState extends State<bbsc_mainPage> {
  DateTime selectedDate = DateTime.now(); // 初始日期为当前日期

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 8,right: 0,top: 20,bottom: 10),  // 这里设定了所有方向的外边距为16像素
            child: Text(
              '选择报表类型',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          _buildFunctionButtons(),
          Padding(
            padding: EdgeInsets.only(left: 8,right: 0,top: 30,bottom: 20),  // 这里设定了所有方向的外边距为16像素
            child: Text(
              '选择报表日期',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          _buildDatePicker(context),
          Padding(
            padding: EdgeInsets.only(left: 8,right: 0,top: 30,bottom: 16),  // 这里设定了所有方向的外边距为16像素
            child: Text(
              '选择导出格式',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          _buildExportButtons(),
          SizedBox(height: 20,),
          _buildButtonDC('导出', Colors.blue),
        ],
      ),
    );
  }

  Widget _buildFunctionButtons() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      // 横向间隔
      mainAxisSpacing: 10,
      // 纵向间隔
      childAspectRatio: 2,
      // 调整子元素宽高比
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      children: <Widget>[
        _buildButton('收支报表', Colors.pinkAccent),
        _buildButton('资产负债表', Colors.lightGreen),
        _buildButton('利润表', Colors.lightBlueAccent),
      ],
    );
  }

  Widget _buildButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        primary: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(text,style: TextStyle(fontSize: 18),),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.calendar_today),
          labelText: '选择报表日期',
        ),
        readOnly: true,
        onTap: () => _selectDate(context),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Widget _buildExportButtons() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      // 横向间隔
      mainAxisSpacing: 10,
      // 纵向间隔
      childAspectRatio: 3,
      // 调整子元素宽高比
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      children: <Widget>[
        _buildButton('Excal', Colors.green),
        _buildButton('PDF', Colors.red),
      ],
    );
  }

  Widget _buildButtonDC(String text, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        primary: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(vertical: 16),  // 增加垂直填充以增加按钮的高度
      ),
      child: Text(text, style: TextStyle(fontSize: 20)),
    );
  }

}

