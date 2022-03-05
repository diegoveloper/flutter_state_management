import 'package:flutter/material.dart';
import 'package:flutter_state_management/data.dart';

class MyChangeNotifier extends ChangeNotifier {
  bool isDark = false;

  void updateTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}

class MyInheritedWidget extends InheritedWidget {
  const MyInheritedWidget({
    required Widget child,
    required this.myChangeNotifier,
    Key? key,
  }) : super(child: child, key: key);

  final MyChangeNotifier myChangeNotifier;

  static MyInheritedWidget of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<MyInheritedWidget>()!;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

class MainChangeNotifier extends StatefulWidget {
  const MainChangeNotifier({Key? key}) : super(key: key);

  @override
  State<MainChangeNotifier> createState() => _MainStatefulState();
}

class _MainStatefulState extends State<MainChangeNotifier> {
  final _myChangeNotifier = MyChangeNotifier();

  @override
  Widget build(BuildContext context) {
    return MyInheritedWidget(
      myChangeNotifier: _myChangeNotifier,
      child: AnimatedBuilder(
          animation: _myChangeNotifier,
          builder: (context, snapshot) {
            return MaterialApp(
              theme: _myChangeNotifier.isDark
                  ? ThemeData.dark()
                  : ThemeData.light(),
              home: const HomeChangeNotifier(),
            );
          }),
    );
  }
}

class HomeChangeNotifier extends StatefulWidget {
  const HomeChangeNotifier({Key? key}) : super(key: key);

  @override
  State<HomeChangeNotifier> createState() => _HomeStatefulState();
}

class _HomeStatefulState extends State<HomeChangeNotifier> {
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
                    value: true,
                    activeColor: Colors.pink,
                    onChanged: (val) {},
                  ),
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
                    builder: (_) => const FutureChangeNotifier(),
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
      title: const Text('ChangeNotifier'),
      actions: [
        IconButton(
          onPressed: () {
            MyInheritedWidget.of(context).myChangeNotifier.updateTheme();
          },
          icon: const Icon(Icons.light_mode),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class FutureChangeNotifier extends StatefulWidget {
  const FutureChangeNotifier({Key? key}) : super(key: key);

  @override
  State<FutureChangeNotifier> createState() => _FutureStatefulState();
}

class MyFutureNotifier extends ChangeNotifier {
  List<String>? courses;

  Future<void> load() async {
    courses = null;
    notifyListeners();
    courses = await getCourses();
    notifyListeners();
  }
}

class _FutureStatefulState extends State<FutureChangeNotifier> {
  final _myFutureNotifier = MyFutureNotifier();

  @override
  void initState() {
    _myFutureNotifier.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FutureBuilder - ChangeNotifier'),
        actions: [
          IconButton(
            onPressed: () {
              _myFutureNotifier.load();
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
              AnimatedBuilder(
                animation: _myFutureNotifier,
                builder: (context, _) {
                  final data = _myFutureNotifier.courses;
                  if (data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (data.isNotEmpty) {
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
