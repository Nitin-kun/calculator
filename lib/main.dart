import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";
  String _currentInput = "";
  double _result = 0.0;

  void _handleButtonPress(String value) {
    setState(() {
      if (value == "C") {
        _output = "0";
        _currentInput = "";
        _result = 0.0;
      } else if (value == "=") {
        try {
          _result = eval(_currentInput);
          _output = _result.toString();
        } catch (e) {
          _output = "Error";
        }
        _currentInput = "";
      } else {
        if (_output == "0" || _output == "Error") {
          _output = value;
        } else {
          _output += value;
        }
        _currentInput += value;
        _output = _currentInput;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.bottomRight,
              child: Text(
                _output,
                style: TextStyle(fontSize: 36.0),
              ),
            ),
          ),
          Divider(height: 1.0),
          buildButtonRow(["7", "8", "9", "/"]),
          buildButtonRow(["4", "5", "6", "x"]),
          buildButtonRow(["1", "2", "3", "-"]),
          buildButtonRow(["C", "0", "=", "+"]),
        ],
      ),
    );
  }

  Widget buildButtonRow(List<String> buttons) {
    return Expanded(
      child: Row(
        children: buttons
            .map(
              (button) => Expanded(
                child: TextButton(
                  onPressed: () => _handleButtonPress(button),
                  child: Text(
                    button,
                    style: TextStyle(fontSize: 24.0),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  double eval(String expression) {
    Parser parser = Parser();
    Expression exp = parser.parse(expression);
    ContextModel contextModel = ContextModel();

    return exp.evaluate(EvaluationType.REAL, contextModel);
  }
}
