import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => TextNotifier(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  title: Text(
                    context.watch<TextNotifier>().text,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
                const SizedBox(height: 20),
                ListTile(
                  title: Text(
                    context.watch<TextNotifier>().result,
                    style: TextStyle(fontSize: 28, color: Colors.green),
                    textAlign: TextAlign.right,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
                const SizedBox(height: 40),
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: [
                    NumberButton(num: "1"),
                    NumberButton(num: "2"),
                    NumberButton(num: "3"),
                    FunctionButton(symbol: "+"),
                    NumberButton(num: "4"),
                    NumberButton(num: "5"),
                    NumberButton(num: "6"),
                    FunctionButton(symbol: "-"),
                    NumberButton(num: "7"),
                    NumberButton(num: "8"),
                    NumberButton(num: "9"),
                    FunctionButton(symbol: "*"),
                    NumberButton(num: "0"),
                    FunctionButton(symbol: "X"),
                    FunctionButton(symbol: "AC"),
                    FunctionButton(symbol: "/"),
                  ],
                ),
                SubmitButton(work: "Submit"),
                SubmitButton(work: "Clear"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NumberButton extends StatelessWidget {
  final String num;
  const NumberButton({required this.num, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<TextNotifier>().updateText(num);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        num,
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class FunctionButton extends StatelessWidget {
  final String symbol;
  const FunctionButton({required this.symbol, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        switch (symbol) {
          case "+":
            context.read<TextNotifier>().addText();
            break;
          case "-":
            context.read<TextNotifier>().subtractText();
            break;
          case "*":
            context.read<TextNotifier>().multiplyText();
            break;
          case "/":
            context.read<TextNotifier>().divideText();
            break;
          case "AC":
            context.read<TextNotifier>().removeAllText();
            break;
          case "X":
            context.read<TextNotifier>().removeText();
            break;
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        symbol,
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

// ignore: must_be_immutable
class SubmitButton extends StatelessWidget {
  SubmitButton({super.key, required this.work});
  String work;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200, // Set a fixed width for the button
        child: ElevatedButton(
          onPressed: () {
            switch (work) {
              case "Submit":
                context
                    .read<TextNotifier>()
                    .finalAnswer(context.read<TextNotifier>().text);
                break;
              case "Clear":
                context.read<TextNotifier>().clearAnswer();
                break;
              default:
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            work,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class TextNotifier extends ChangeNotifier {
  String _text = "";
  String _result = "---";

  String get text => _text;
  String get result => _result;

  void finalAnswer(String userExpression) {
    try {
      Parser parser = Parser();
      Expression parsedExpression = parser.parse(userExpression);
      ContextModel contextModel = ContextModel();
      double eval =
          parsedExpression.evaluate(EvaluationType.REAL, contextModel);

      _result = eval.toString();
      notifyListeners();
    } catch (e) {
      _result = "Error: ${e.toString()}";
      notifyListeners();
    }
  }

  void clearAnswer() {
    _text = "";
    _result = "";
    notifyListeners();
  }

  void updateText(String newText) {
    _text = _text + newText;
    notifyListeners();
  }

  void multiplyText() {
    _text = _text + "*";
    notifyListeners();
  }

  void divideText() {
    _text = _text + "/";
    notifyListeners();
  }

  void addText() {
    _text = _text + "+";
    notifyListeners();
  }

  void subtractText() {
    _text = _text + "-";
    notifyListeners();
  }

  void removeText() {
    if (_text.isNotEmpty) {
      _text = _text.substring(0, _text.length - 1);
      notifyListeners();
    }
  }

  void removeAllText() {
    _text = "";
    notifyListeners();
  }
}
