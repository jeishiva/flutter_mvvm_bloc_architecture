import 'package:flutter/material.dart';
import 'package:flutter_mvvm_bloc_architecture/di/injector.dart';
import 'package:flutter_mvvm_bloc_architecture/presentation/pages/product_page.dart';

void main() {
  initInjector();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Big Billion App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      home: const ProductPage(),
    );
  }
}

class MultiDevicePage extends StatelessWidget {
  const MultiDevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return const PhonePage();
        } else {
          return const TabletPage();
        }
      },
    );
  }
}

class PhonePage extends StatelessWidget {
  const PhonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Flexible(flex: 1, child: Container(color: Colors.green)),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Flexible(flex: 1, child: Container(color: Colors.blue)),
                Flexible(flex: 1, child: Container(color: Colors.lightGreen)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TabletPage extends StatelessWidget {
  const TabletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // small
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Container(
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.all(8),
                          child: Container(
                            color: Colors.red,
                            height: 50,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          width: 100,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8),
                          child: Container(
                            color: Colors.green,
                            height: 50,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          alignment: Alignment.bottomRight,
                          padding: EdgeInsets.all(8),
                          child: Container(
                            color: Colors.cyan,
                            height: 50,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Container(color: Colors.blue)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(flex: 1, child: Container(color: Colors.red)),
                Flexible(flex: 1, child: Container(color: Colors.amber)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
