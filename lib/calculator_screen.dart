import 'package:calculator/button_values.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = ''; // First number
  String operand = ''; // Operator
  String number2 = ''; // Second number
  String result = ''; // Result of calculation

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    result.isNotEmpty ? result : "$number1$operand$number2",
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (value) => SizedBox(
                      height: (screenSize.width / 5),
                      width: value == Btn.n0
                          ? screenSize.width / 2
                          : (screenSize.width / 4),
                      child: buildButton(value),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void onBtnTap(String value) {
    setState(() {
      if (value == Btn.clr) {
        clear();
      } else if (value == Btn.del) {
        delete();
      } else if (value == Btn.calculate) {
        calculate();
      } else if (value == Btn.dot || int.tryParse(value) != null) {
        // It's a number or a dot
        if (operand.isEmpty) {
          number1 += value;
        } else {
          number2 += value;
        }
      } else {
        // It's an operator
        if (number1.isNotEmpty && number2.isEmpty) {
          operand = value;
        }
      }
    });
  }

  void clear() {
    number1 = '';
    operand = '';
    number2 = '';
    result = '';
  }

  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = '';
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }
  }

  void calculate() {
    double num1 = double.parse(number1);
    double num2 = double.parse(number2);
    double res;

    switch (operand) {
      case Btn.add:
        res = num1 + num2;
        break;
      case Btn.subtract:
        res = num1 - num2;
        break;
      case Btn.multiply:
        res = num1 * num2;
        break;
      case Btn.divide:
        res = num1 / num2;
        break;
      default:
        return;
    }

    result = res.toString();
    number1 = result;
    operand = '';
    number2 = '';
  }

  Widget buildButton(String value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getButtonColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Color getButtonColor(String value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blueGrey
        : [
            Btn.per,
            Btn.multiply,
            Btn.add,
            Btn.subtract,
            Btn.divide,
            Btn.calculate
          ].contains(value)
            ? Colors.orange
            : Colors.black87;
  }
}
