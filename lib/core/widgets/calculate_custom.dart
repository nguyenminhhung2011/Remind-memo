import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:project/app_coordinator.dart';
import 'package:project/core/extensions/context_exntions.dart';

class CalculatorCustom extends StatefulWidget {
  final int inputPrice;
  const CalculatorCustom({
    super.key,
    required this.inputPrice,
  });

  @override
  State<CalculatorCustom> createState() => _CalculatorCustomState();
}

class _CalculatorCustomState extends State<CalculatorCustom> {
  final ValueNotifier<String> _stringDisplay = ValueNotifier<String>('');
  double currentData = 0;
  final List<String> buttons = [
    'C',
    '+/2',
    '%',
    'DEL',
    '7',
    '8',
    '9',
    '/',
    '4',
    '5',
    '6',
    'x',
    '1',
    '2',
    '3',
    '-',
    '0',
    '.000',
    '=',
    '+',
  ];
  List<int> primaryColorContains = [0, 1, 2, 7, 11, 15, 19];
  List<int> calculateString = [2, 7, 11, 15, 19];
  bool isOut = true;

  void _onButtonTaps(int index) {
    if (isOut && index != 18) {
      setState(() {
        isOut = false;
      });
    }
    if (index == 0) {
      _stringDisplay.value = '0';
      return;
    }
    if (index == 3) {
      _stringDisplay.value =
          _stringDisplay.value.substring(0, _stringDisplay.value.length - 1);
      if (_stringDisplay.value.isEmpty) {
        _stringDisplay.value = '0';
      }
      return;
    }
    if (index == 18) {
      isOut
          ? context.popArgs(double.parse(_stringDisplay.value))
          : setState(() {
              isOut = true;
            });
      equalPressed();
      return;
    }
    if (index == 17) {
      if (calculateString
          .map((e) => buttons[e])
          .toList()
          .contains(_stringDisplay.value[_stringDisplay.value.length - 1])) {
        return;
      }
      _stringDisplay.value += '000';
      return;
    }
    if (calculateString.contains(index)) {
      if (calculateString
          .map((e) => buttons[e])
          .toList()
          .contains(_stringDisplay.value[_stringDisplay.value.length - 1])) {
        return;
      }
      _stringDisplay.value += buttons[index];
      return;
    }
    if (_stringDisplay.value == '0') {
      _stringDisplay.value = '';
    }
    _stringDisplay.value += buttons[index];
  }

  bool isOperator(String x) {
    if (x == '/' || x == 'x' || x == '-' || x == '+' || x == '=') {
      return true;
    }
    return false;
  }

// function to calculate the input operation
  void equalPressed() {
    String finalUserInput = _stringDisplay.value;
    finalUserInput = _stringDisplay.value.replaceAll('x', '*');

    Parser p = Parser();
    Expression exp = p.parse(finalUserInput);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    _stringDisplay.value = eval.round().toString();
    setState(() {
      isOut = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _stringDisplay.value = widget.inputPrice.toString();
    currentData = widget.inputPrice.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: context.heightDevice * 0.71,
      child: Column(
        children: [
          ValueListenableBuilder(
              valueListenable: _stringDisplay,
              builder: (context, stringDisplay, _) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  width: double.infinity,
                  height: context.heightDevice * 0.12,
                  color: Theme.of(context).cardColor,
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    children: [
                      Text(
                        stringDisplay,
                        style: context.headlineLarge.copyWith(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                );
              }),
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: GridView.count(
                childAspectRatio: 1.07,
                crossAxisCount: 4,
                children: buttons.mapIndexed((index, element) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(10.0),
                    onTap: () => _onButtonTaps(index),
                    child: Container(
                      margin: const EdgeInsets.all(2.0),
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: index == 3
                            ? Colors.red
                            : primaryColorContains.contains(index)
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).cardColor,
                      ),
                      child: Center(
                        child: isOut && index == 18
                            ? const Icon(Icons.check, color: Colors.green)
                            : Text(
                                buttons[index],
                                style: context.titleLarge,
                              ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
