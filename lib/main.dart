import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

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
        _clearOutput();
      } else if (value == "=") {
        _evaluateExpression();
      } else {
        _appendValueToOutput(value);
      }
    });
  }

  void _clearOutput() {
    _output = "0";
    _currentInput = "";
    _result = 0.0;
  }

  void _evaluateExpression() {
    try {
      _result = eval(_currentInput);
      _output = _result.toString();
    } catch (e) {
      _output = "Error: $e";
    }
    _currentInput = "";
  }

  void _appendValueToOutput(String value) {
    if (_output == "0" || _output == "Error") {
      _output = value;
    } else {
      _output += value;
    }

    _currentInput += value;
    _output = _currentInput;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                color: Colors.black,
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.bottomRight,
                child: Text(
                  _output,
                  style: const TextStyle(fontSize: 36.0, color: Colors.white),
                ),
              ),
            ),
          ),
          const Divider(height: 1.0),
          buildButtonRow(["7", "8", "9", "/"]),
          buildButtonRow(["4", "5", "6", "*"]),
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
                    style: const TextStyle(fontSize: 24.0),
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
    print(exp.evaluate(EvaluationType.REAL, contextModel));

    return exp.evaluate(EvaluationType.REAL, contextModel);
  }
}
