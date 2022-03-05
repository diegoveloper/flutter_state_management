import 'package:flutter/material.dart';
import 'package:flutter_state_management/data.dart';

class MyInheritedWidget extends InheritedWidget {
  const MyInheritedWidget({
    required Widget child,
    required this.onThemeChanged,
    this.onThemeString,
    Key? key,
  }) : super(child: child, key: key);

  final VoidCallback onThemeChanged;
  final ValueChanged<String>? onThemeString;

  static MyInheritedWidget of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<MyInheritedWidget>()!;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

class MainStateful extends StatefulWidget {
  const MainStateful({Key? key}) : super(key: key);

  @override
  State<MainStateful> createState() => _MainStatefulState();
}

class _MainStatefulState extends State<MainStateful> {
  var isDark = true;

  @override
  Widget build(BuildContext context) {
    return MyInheritedWidget(
      onThemeChanged: () {
        setState(() {
          isDark = !isDark;
        });
      },
      onThemeString: (val) {
        print('Val: $val');
      },
      child: MaterialApp(
        theme: isDark ? ThemeData.dark() : ThemeData.light(),
        home: const HomeStateful(),
      ),
    );
  }
}

class HomeStateful extends StatefulWidget {
  const HomeStateful({Key? key}) : super(key: key);

  @override
  State<HomeStateful> createState() => _HomeStatefulState();
}

class _HomeStatefulState extends State<HomeStateful> {
  bool _checked = false;
  final _checkList = List.generate(courses.length, (index) => false);

  @override
  Widget build(BuildContext context) {
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
                  Checkbox(
                    value: _checked,
                    activeColor: Colors.pink,
                    onChanged: (val) {
                      setState(() {
                        _checked = val!;
                      });
                    },
                  ),
                ],
              ),
            ),
            ...List.generate(courses.length, (index) {
              final course = courses[index];
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(course),
                    Checkbox(
                      value: _checkList[index],
                      activeColor: Colors.pink,
                      onChanged: (val) {
                        setState(() {
                          _checkList[index] = val!;
                        });
                      },
                    ),
                  ],
                ),
              );
            }),
            const Spacer(),
            MaterialButton(
              color: Theme.of(context).splashColor,
              child: const Text('Future Screen'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const FutureStateful(),
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
      title: const Text('Stateful'),
      actions: [
        IconButton(
          onPressed: () {
            MyInheritedWidget.of(context).onThemeChanged();
          },
          icon: const Icon(Icons.light_mode),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class FutureStateful extends StatefulWidget {
  const FutureStateful({Key? key}) : super(key: key);

  @override
  State<FutureStateful> createState() => _FutureStatefulState();
}

class _FutureStatefulState extends State<FutureStateful> {
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
        title: const Text('FutureBuilder - Stateful'),
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
