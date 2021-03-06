import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '今天吃什么选择器 - zznQ',
      themeMode: ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
            title: const Text(
              '今天吃什么选择器',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            backgroundColor: Colors.white,
            toolbarHeight: 35),
        body: const Center(
          child: FoodsSelector(),
        ),
      ),
    );
  }
}

class FoodsSelector extends StatefulWidget {
  const FoodsSelector({Key? key}) : super(key: key);

  @override
  State<FoodsSelector> createState() => _FoodsSelectorState();
}

class _FoodsSelectorState extends State<FoodsSelector> {
  bool _running = true;
  final _foods = <Image>[
    const Image(image: AssetImage('resource/logo.png'), width: 200, height: 200)
  ];
  int _index = 0;
  int kfc = 0;
  void run() async {
    kfc = await _initFoods();
  }

  @override
  void initState() {
    run();
    super.initState();
    int count = 0;
    const period = Duration(milliseconds: 60);
    Timer.periodic(period, (timer) {
      if (_running) {
        setState(() {
          _index = count % _foods.length;
        });
      } else {
        // 彩蛋：kfc_V_me50
        if (DateTime.now().weekday == 4) {
          setState(() {
            _index = kfc;
          });
        }
      }
      count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 5),
        _foods[_index],
        TextButton(
          child: Text(_running ? '停止' : '开始'),
          onPressed: () {
            setState(() {
              _running = !_running;
            });
          },
        ),
      ],
    );
  }

  Future<int> _initFoods() async {
    int kfc = 0;
    final Map<String, dynamic> assets =
        jsonDecode(await rootBundle.loadString('AssetManifest.json'));
    assets.keys
        .where((String key) =>
            key.contains('resource/foods/') && key.contains('.png'))
        .toList()
        .forEach((element) {
      if (element.contains('19.png')) {
        kfc = _foods.length - 1;
      }
      _foods.add(Image(image: AssetImage(element), width: 200, height: 200));
    });
    _foods.removeAt(0);
    return kfc;
  }
}
