import 'package:flutter/material.dart';
import 'package:tuning_table/tuning_table.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tuning Table',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controllerTable = TuningTableController(
    horizontalLabels: <double>[
      0,
      1333,
      2667,
      4000,
      5333,
      6667,
      8000,
      9000,
      10667,
      12000,
      13333,
      14667,
      16000,
      17333,
      18887,
      20000
    ],
    verticalLabels: <double>[98, 85, 75, 50, 25, 12, 1, 0],
  );
  final newV = <double>[80,70,60, 30, 45, 30, 25, 12, 1, 0];
  final newH = <double>[
    0,
    1333,
    2667,
    3000,
    3333,
    4667,
    5000,
    5200,
    6667,
    7200,
    7333,
    8667,
    9000,
    10333,
    11887,
    12000
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TuningTable2dView(
                width: 800,
                height: 250,
                horizontalName: 'RPM',
                verticalName: 'TPS',
                controller: controllerTable,
              ),
              Wrap(
                spacing: 10,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      controllerTable.calculator(
                        TuningCalculatorType.step,
                        -10,
                      );
                    },
                    child: const Text('-10'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controllerTable.calculator(
                        TuningCalculatorType.step,
                        10,
                      );
                    },
                    child: const Text('+10'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controllerTable.calculator(
                        TuningCalculatorType.percent,
                        10,
                      );
                    },
                    child: const Text('P 10'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controllerTable.calculator(
                        TuningCalculatorType.numeric,
                        40,
                      );
                    },
                    child: const Text('N 40'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controllerTable.interpolation(
                        TuningAxisType.horizontal,
                      );
                    },
                    child: const Text('I H'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controllerTable.interpolation(
                        TuningAxisType.vertical,
                      );
                    },
                    child: const Text('I V'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controllerTable.interpolation(
                        TuningAxisType.cross,
                      );
                    },
                    child: const Text('I C'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controllerTable.toggleSettingLabel();
                    },
                    child: const Text('Setting'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controllerTable.setVerticalLabels(newV);
                    },
                    child: const Text('new V'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controllerTable.setHorizontalLabels(newH);
                    },
                    child: const Text('new H'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controllerTable.setLabels(newV, newH);
                    },
                    child: const Text('new H V'),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
