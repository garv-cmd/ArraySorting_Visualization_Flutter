import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

var t = 0;

class _MyHomePageState extends State<MyHomePage> {
  StreamController<List<int>> _streamController;
  Stream<List<int>> _stream;

  List<int> _numbers = [];

  int _size = 500;
  _randomize() {
    setState(() {
      t = 0;
    });

    _numbers = [];
    for (var i = 0; i < _size; ++i) {
      _numbers.add(Random().nextInt(_size));
    }
    _streamController.add(_numbers);
  }

  var time = '';
  _selectionSort() async {
    Stopwatch stopwatch = new Stopwatch()..start();
    for (int i = 0; i < _numbers.length; i++) {
      for (int j = i + 1; j < _numbers.length; j++) {
        if (_numbers[i] > _numbers[j]) {
          int temp = _numbers[j];
          _numbers[j] = _numbers[i];
          _numbers[i] = temp;
        }
        await Future.delayed(Duration(microseconds: 500));
        _streamController.add(_numbers);
      }
    }
    stopwatch.stop();
    setState(() {
      t = stopwatch.elapsed.inSeconds;
      print(stopwatch.elapsed.inSeconds);
    });
  }

  _sort() async {
    Stopwatch stopwatch = new Stopwatch()..start();
    for (int i = 0; i < _numbers.length; ++i) {
      for (int j = 0; j < _numbers.length - i - 1; ++j) {
        if (_numbers[j] > _numbers[j + 1]) {
          int temp = _numbers[j];
          _numbers[j] = _numbers[j + 1];
          _numbers[j + 1] = temp;
        }
        await Future.delayed(Duration(microseconds: 500));
        _streamController.add(_numbers);
      }
    }
    stopwatch.stop();
    setState(() {
      t = stopwatch.elapsed.inSeconds;
      print(stopwatch.elapsed.inSeconds);
    });
  }

  String title = 'Bubble Sort';

  _setSortAlgo(String value) {
    if (value == 'bubble') {
      setState(() {
        title = "Bubble Sort";
      });
    }
    if (value == 'selection') {
      setState(() {
        title = "Selection Sort";
      });
    }
  }

  _sortSelect() {
    if (title == 'Bubble Sort') {
      _sort();
    }
    if (title == 'Selection Sort') {
      _selectionSort();
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _streamController = StreamController<List<int>>();
    _stream = _streamController.stream;
    _randomize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
        ),
        leading: Center(
            child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(' Time: $t sec'),
        )),
        // backgroundColor: Colors.purple,
        actions: [
          PopupMenuButton(
            itemBuilder: (ctx) {
              return [
                PopupMenuItem(
                  value: 'bubble',
                  child: Text("Bubble Sort"),
                ),
                PopupMenuItem(
                  value: 'selection',
                  child: Text("Selection Sort"),
                ),
              ];
            },
            onSelected: (String value) {
              _randomize();
              _setSortAlgo(value);
            },
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
//        mainAxisAlignment: MainAxisAlignment.center,
//        crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: FlatButton(
                child: Text('Randomize'),
                onPressed: _randomize,
              ),
            ),
            Expanded(
              child: FlatButton(
                child: Text('Sort'),
                onPressed: _sortSelect,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: StreamBuilder(
          stream: _stream,
          builder: (context, snapshot) {
            var counter = 0;
            return Row(
              children: _numbers.map((int number) {
                counter++;
                return CustomPaint(
                  painter: BarPainter(
                    width: MediaQuery.of(context).size.width / _size,
                    value: number,
                    index: counter,
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

class BarPainter extends CustomPainter {
  final double width;
  final int value;
  final int index;
  BarPainter({this.width, this.value, this.index});
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = Paint();
    if (this.value < 500 * .10) {
      paint.color = Color.fromRGBO(180, 220, 245, 1);
    } else if (this.value < 500 * .20) {
      paint.color = Color.fromRGBO(175, 210, 240, 1);
    } else if (this.value < 500 * .30) {
      paint.color = Color.fromRGBO(169, 199, 230, 1);
    } else if (this.value < 500 * .40) {
      paint.color = Color.fromRGBO(159, 191, 223, 1);
    } else if (this.value < 500 * .50) {
      paint.color = Color.fromRGBO(140, 179, 217, 1);
    } else if (this.value < 500 * .60) {
      paint.color = Color.fromRGBO(121, 166, 210, 1);
    } else if (this.value < 500 * .70) {
      paint.color = Color.fromRGBO(102, 153, 204, 1);
    } else if (this.value < 500 * .80) {
      paint.color = Color.fromRGBO(83, 140, 198, 1);
    } else if (this.value < 500 * .90) {
      paint.color = Color.fromRGBO(64, 128, 191, 1);
    } else {
      paint.color = Color.fromRGBO(57, 115, 172, 1);
    }
    paint.strokeWidth = width;
    paint.strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(index * width, 0),
        Offset(index * width, value.ceilToDouble()), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
