import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Lab01',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Laboratory 01'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final TextEditingController _controller = TextEditingController();

  void _handleInputChange() {
    final String input = _controller.text;

    setState(() {
      if (input == '!ZERO') {
        _counter = 0;
      } else {
        final int? parsedNumber = int.tryParse(input);
        if (parsedNumber != null) {
          _counter += parsedNumber;
        }else{
          _showErrorDialog('Invalid input. Please enter a number or "!ZERO".');
        }
      }
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Counter',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: _counter > 0 ? Colors.green : Colors.red,
              ) ,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Enter a number or !ZERO to reset',
                ),
                onSubmitted: (_) => _handleInputChange(),
              ),
            ),
            ElevatedButton(
              onPressed: _handleInputChange,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
