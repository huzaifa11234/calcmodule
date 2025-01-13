import 'package:flutter/material.dart';

import 'button_values.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String num1 = "";
  String oper = "";
  String num2 = "";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      backgroundColor: Colors.white30,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(20),
                  child: Text("$num1$oper$num2".isEmpty
                      ? "0"
                      : "$num1$oper$num2",
                    style: const TextStyle(fontWeight: FontWeight.bold,
                        fontSize: 55
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            Wrap(
              children: Btn.buttonValues.
              map(
                    (value) =>
                    SizedBox(
                      width: value == Btn.n0
                          ? screenSize.width / 2 : (screenSize.width / 4),
                      height: screenSize.height / 8,
                      child: buildButton(value),
                    ),
              )
                  .toList(),
            )
          ],),
      ),
    );
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide:  const BorderSide(
            color: Colors.white30,
          ),
          borderRadius: BorderRadius.circular(80),
        ),
        child: InkWell(
            onTap: () => onBtnTap(value),
            child: Center(
                child: Text(value,
                  style: const TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.bold),
                )
            )),
      ),
    );
  }

  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }
    if (value == Btn.clr) {
      ClearAll();
      return;
    }
    if (value == Btn.per) {
      ConvertToPercentage();
      return;
    }
    if(value==Btn.calculate){
      calculate();
      return;
    }
    //check if operand is not "."
    if (value != Btn.dot && int.tryParse(value) == null) {
      //operand pressed
      if (oper.isNotEmpty && num2.isNotEmpty) {
        calculate();
      }
      oper = value;
    }
    //assign a value to a num1
    else if (num1.isEmpty || oper.isEmpty) {
      //check if value is ".":: Ex "1.2"
      if (value == Btn.dot && num1.contains(Btn.dot)) return;
      if (value == Btn.dot && (num1.isEmpty || num1 == Btn.dot)) {
        //check num1 is "." | 0
        value = "0.";
      }
      num1 += value;
    }
    //assign a value to a num2
    else if (num2.isEmpty || oper.isNotEmpty) {
      //check if value is ".":: Ex "1.2"
      if (value == Btn.dot && num2.contains(Btn.dot)) return;
      if (value == Btn.dot && (num2.isEmpty || num2 == Btn.dot)) {
        //check num2 is "." | 0
        value = "0.";
      }
      num2 += value;
    }
    setState(() {}
    );
  }
  void calculate(){
    if(num1.isEmpty) return;
    if(oper.isEmpty) return;
    if(num2.isEmpty) return;

   final double number1  = double.parse(num1);
   final double number2  = double.parse(num2);

    var result= 0.0;

    switch (oper){
      case Btn.add:
          result= number1 + number2;
        break;
      case Btn.subtract:
        result= number1 - number2;
        break;
      case Btn.multiply:
        result= number1 * number2;
        break;
      case Btn.divide:
        result= number1 / number2;
        break;
       default:
    }
    setState(() {
      num1 = "$result";
      //to delete .0 from the result
      if(num1.endsWith(".0")){
        num1=num1.substring(0, num1.length-2);
        oper="";
        num2="";
      }
    });
  }
  void ConvertToPercentage(){
    // 24  +  24 calculate it first and convert after
    if(num1.isNotEmpty&&oper.isNotEmpty&&num2.isNotEmpty){
        calculate();
    }
    if(oper.isNotEmpty){
      return;
    }
    final num =double.parse(num1);
    setState(() {
      num1= "${(num / 100)}";
      oper= "";
      num2= "";
    });
  }
  void ClearAll(){
    setState(() {
      num1 = "";
      oper = "";
      num2 = "";
    });
  }

  void delete() {
    // to delete one number from the end
    if (num2.isNotEmpty) {
      num2 = num2.substring(0, num2.length - 1);
    } else if (oper.isNotEmpty) {
      oper = "";
    }
    else if (num1.isNotEmpty) {
      num1 = num1.substring(0, num1.length - 1);
    }
    setState(() {

    });
  }

  Color getBtnColor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blueGrey
        : [ Btn.per,
      Btn.multiply,
      Btn.divide,
      Btn.add,
      Btn.subtract,
      Btn.calculate,
    ].contains(value) ? Colors.orange : Colors.black87;
  }
}