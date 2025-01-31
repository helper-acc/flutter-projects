import 'package:flutter/material.dart';
import 'package:flashlight/flashlight.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FlashlightPage(),
    );
  }
}

class FlashlightPage extends StatefulWidget {
  const FlashlightPage({super.key});

  @override
  _FlashlightPageState createState() => _FlashlightPageState();
}

class _FlashlightPageState extends State<FlashlightPage> {
  bool _isLightOn = false;

  void _toggleLight() async {
    try {
      await Flashlight.onLight(!_isLightOn);
      setState(() {
        _isLightOn = !_isLightOn;
      });
    } catch (e) {
      // Виводимо попередження якщо платформа не підтримується
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK'))
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flashlight Control')),
      body: Center(
        child: ElevatedButton(
          onPressed: _toggleLight,
          child: Text(_isLightOn ? 'Turn Off' : 'Turn On'),
        ),
      ),
    );
  }
}
