import 'package:cleanarch_project/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:flutter/material.dart';
import "injection_container.dart" as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await di.sl.allReady();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Number Trivia",
      home: NumberTriviaPage(),
    );
  }
}
