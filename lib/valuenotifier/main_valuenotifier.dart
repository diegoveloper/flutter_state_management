import 'package:flutter/material.dart';
import 'package:flutter_state_management/data.dart';

class MyInheritedWidget extends InheritedWidget {
  const MyInheritedWidget({
    required Widget child,
    required this.myValueNotifier,
    Key? key,
  }) : super(child: child, key: key);

  final ValueNotifier<bool> myValueNotifier;

  static MyInheritedWidget of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<MyInheritedWidget>()!;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

class MainValueNotifier extends StatefulWidget {
  const MainValueNotifier({Key? key}) : super(key: key);

  @override
  State<MainValueNotifier> createState() => _MainStatefulState();
}

class _MainStatefulState extends State<MainValueNotifier> {
  final _myValueNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return MyInheritedWidget(
      myValueNotifier: _myValueNotifier,
      child: ValueListenableBuilder<bool>(
        valueListenable: _myValueNotifier,
        builder: (context, isDark, child) {
          print('ValueNotifier: $isDark');
          return MaterialApp(
            theme: isDark ? ThemeData.dark() : ThemeData.light(),
            home: child,
          );
        },
        child: const HomeValueNotifier(),
      ),
    );
  }
}

class HomeValueNotifier extends StatefulWidget {
  const HomeValueNotifier({Key? key}) : super(key: key);

  @override
  State<HomeValueNotifier> createState() => _HomeStatefulState();
}

class _HomeStatefulState extends State<HomeValueNotifier> {
  final _myCheckNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    print('BUILD Home notifier');
    return SafeArea(
      child: Scaffold(
        appBar: const MyAppBar(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('CheckBox'),
                  ValueListenableBuilder<bool>(
                      valueListenable: _myCheckNotifier,
                      builder: (context, value, snapshot) {
                        return Checkbox(
                          value: value,
                          activeColor: Colors.pink,
                          onChanged: (val) {
                            _myCheckNotifier.value = val!;
                          },
                        );
                      }),
                ],
              ),
            ),
            const Spacer(),
            MaterialButton(
              color: Theme.of(context).splashColor,
              child: const Text('Future Screen'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const FutureValueNotifier(),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('ValueNotifier'),
      actions: [
        IconButton(
          onPressed: () {
            final inherited = MyInheritedWidget.of(context);
            inherited.myValueNotifier.value = !inherited.myValueNotifier.value;
          },
          icon: const Icon(Icons.light_mode),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class FutureValueNotifier extends StatefulWidget {
  const FutureValueNotifier({Key? key}) : super(key: key);

  @override
  State<FutureValueNotifier> createState() => _FutureStatefulState();
}

class _FutureStatefulState extends State<FutureValueNotifier> {
  late Future<List<String>> _futureData;

  @override
  void initState() {
    _futureData = getCourses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FutureBuilder - ValueNotifier'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _futureData = getCourses();
              });
            },
            icon: const Icon(Icons.refresh_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const TextField(
                decoration: InputDecoration(),
              ),
              const SizedBox(height: 30),
              FutureBuilder<List<String>>(
                future: _futureData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.hasData) {
                      final data = snapshot.data!;
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(data[index]),
                          );
                        },
                      );
                    }
                  }
                  return const Center(
                    child: Text('Empty'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
