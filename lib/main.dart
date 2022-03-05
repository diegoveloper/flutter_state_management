import 'package:flutter/material.dart';
import 'package:flutter_state_management/changenotifier/main_changenotifier.dart';
import 'package:flutter_state_management/stateful/main_stateful.dart';
import 'package:flutter_state_management/valuenotifier/main_valuenotifier.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  void _goTo(BuildContext context, Widget widget) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => widget,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).splashColor;
    return Scaffold(
      appBar: AppBar(
        title: const Text('State Management Basics'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              MaterialButton(
                color: color,
                child: const Text('Stateful Widget'),
                onPressed: () => _goTo(context, const MainStateful()),
              ),
              MaterialButton(
                color: color,
                child: const Text('ChangeNotifier'),
                onPressed: () => _goTo(context, const MainChangeNotifier()),
              ),
              MaterialButton(
                color: color,
                child: const Text('ValueNotifier'),
                onPressed: () => _goTo(context, const MainValueNotifier()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
