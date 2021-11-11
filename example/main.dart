import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spatial/spatial.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spatial Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Spatial Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final SpatialContext spatialContext = SpatialContext();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: GestureDetector(
        onScaleUpdate: (details) {
          print('onScale: ${details}');
          spatialContext.positionOffset =
              spatialContext.positionOffset.copy(z: details.scale - 0.5);
        },
        onDoubleTap: () {
          print('onDoubleTap:');
          spatialContext.rotationOffset = Offset3D.zero;
        },
        child: RawKeyboardListener(
            autofocus: true,
            focusNode: FocusNode(),
            onKey: _onKeyEvent,
            child: Spatial(
              child: _defaultApp(context),
              spatialContext: spatialContext,
            )),
      ),
    );
  }

  void _onKeyEvent(RawKeyEvent event) {
    if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
      if (event.isShiftPressed && !event.isControlPressed) {
        print("rotate -Z");
        spatialContext.rotate(z: -1);
        return;
      }
      if (event.isShiftPressed && event.isControlPressed) {
        print("move left");
        spatialContext.move(x: -1);
        return;
      }
      print("rotate Y");
      spatialContext.rotate(y: 1);
    }

    if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      if (event.isShiftPressed && !event.isControlPressed) {
        print("walk front");
        spatialContext.move(z: -1);
        return;
      }
      if (event.isShiftPressed && event.isControlPressed) {
        print("move up");
        spatialContext.move(y: -1);
        return;
      }
      print("rotate X");
      spatialContext.rotate(x: 1);
    }

    if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
      if (event.isShiftPressed && !event.isControlPressed) {
        print("rotate Z");
        spatialContext.rotate(z: 1);
        return;
      }
      if (event.isShiftPressed && event.isControlPressed) {
        print("move right");
        spatialContext.move(x: 1);
        return;
      }
      print("rotate -Y");
      spatialContext.rotate(y: -1);
    }

    if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      if (event.isShiftPressed && !event.isControlPressed) {
        print("walk back");
        spatialContext.move(z: 1);
        return;
      }
      if (event.isShiftPressed && event.isControlPressed) {
        print("move down");
        spatialContext.move(y: 1);
        return;
      }
      print("rotate -X");
      spatialContext.rotate(x: -1);
    }
  }

  Widget _defaultApp(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline1,
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
