import 'package:flutter/material.dart';
import 'package:test_zadanie/checkbox_model.dart';
import 'dart:math';

import 'package:test_zadanie/checkbox_type.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ScrollController _controller = ScrollController();
  final ValueNotifier<CheckboxType> _selectedTypeNotifier = ValueNotifier(CheckboxType.deepOrange);
  final List<CheckboxModel> _checkboxes = [];

  @override
  void initState() {
    super.initState;
    _checkboxes.add(CheckboxModel(type: CheckboxType.deepOrange, isSelected: true));
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.hasClients) {
      setState(() {
        _controller.jumpTo(_controller.position.maxScrollExtent);
      });
    }
    return
      Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              const Spacer(),
              Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.75,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 35, right: 35, top: 35, bottom: 10),
                    child: GridView.builder(
                      controller: _controller,
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 30, // влияет на кол-во виджетов в строке
                        childAspectRatio: 3 / 5, // что-то типа вертикального паддинга
                        crossAxisSpacing: 20, // S между столбцов
                        mainAxisSpacing: 20, // S между строк
                      ),
                      itemCount: _checkboxes.length,
                      shrinkWrap: true,
                      itemBuilder: (_, int index) => InkWell(
                        onTap: () => setState(() {
                          _selectedTypeNotifier.value = _checkboxes[index].type;
                          for (CheckboxModel checkbox in _checkboxes) {
                            checkbox.isSelected = _selectedTypeNotifier.value == checkbox.type;
                          }
                        }),
                        child: CustomPaint(
                          willChange: true,
                          painter:
                              ShapePainter(checkbox: _checkboxes[index], selectedTypeNotifier: _selectedTypeNotifier),
                          child: Container(
                            height: 26,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 15),
                  child: Text('Animation duration'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 45,
                      width: 140,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                        ),
                        onPressed: onPressed,
                        child: const Text('Add checkboxes', style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    const SizedBox(width: 15),
                    SizedBox(
                      height: 45,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _checkboxes.clear();
                          });
                        },
                        child: const Text('Clear', style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }

  void onPressed() {
    final Random randomGenerator = Random();

    List<CheckboxModel> newCheckBoxes = List.generate(10, (index) {
      final int intValue = randomGenerator.nextInt(3);
      CheckboxType type = _definedTypeByInt(intValue);
      bool isSelected =
          _selectedTypeNotifier.value == type;
      return CheckboxModel(type: type, isSelected: isSelected);
    });
    _checkboxes.addAll(newCheckBoxes);
    setState(() {});
  }
}

class ShapePainter extends CustomPainter {
  ShapePainter({required this.checkbox, required this.selectedTypeNotifier}) : super(repaint: selectedTypeNotifier);

  final CheckboxModel checkbox;
  final ValueNotifier<CheckboxType> selectedTypeNotifier;

  static const double radius = 13;

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width / 9;
    final center = Offset(size.width / 2, size.height / 2);

    /// Circle of checkbox setup and drawing
    Paint circle = Paint();
    circle.strokeWidth = strokeWidth;
    circle.color = _defineColorByType(checkbox.type);

    if (checkbox.isSelected) {
      circle.style = PaintingStyle.fill;
    } else {
      circle.style = PaintingStyle.stroke;
    }

    canvas.drawCircle(center, radius, circle);

    /// CheckMark of checkbox setup and drawing
    Paint checkMark = Paint();

    checkMark.strokeWidth = strokeWidth;
    checkMark.color = Colors.white;
    checkMark.style = PaintingStyle.stroke;

    canvas.drawLine(const Offset(7, 24), const Offset(15, 32), checkMark);
    canvas.drawLine(const Offset(15, 32), const Offset(22, 18), checkMark);
  }

  @override
  bool shouldRepaint(ShapePainter oldDelegate) => oldDelegate.selectedTypeNotifier != selectedTypeNotifier;
}

Color _defineColorByType(CheckboxType type) {
  switch (type) {
    case CheckboxType.deepOrange:
      return Colors.deepOrange;
    case CheckboxType.amber:
      return Colors.amber;
    case CheckboxType.lightGreen:
      return Colors.lightGreen;
    default:
      return Colors.deepOrange;
  }
}

CheckboxType _definedTypeByInt(int intValue) {
  switch (intValue) {
    case 0:
      return CheckboxType.deepOrange;
    case 1:
      return CheckboxType.amber;
    case 2:
      return CheckboxType.lightGreen;
    default:
      return CheckboxType.deepOrange;
  }
}
