import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './services/note_service.dart';
import './screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NoteService(sharedPreferences),
        ),
      ],
      child: MaterialApp(
        title: 'Note Calc App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFF48FB1), // Soft pink
            primary: const Color(0xFFF48FB1), // Primary pink
            secondary: const Color(0xFFF8BBD0), // Lighter pink
            onPrimary: Colors.white,
            onSecondary: Colors.black,
            surface: const Color(0xFFFFF0F5), // Very light pink/white
            onSurface: Colors.black87,
          ),
          textTheme: Theme.of(context).textTheme.apply(
            fontFamily: 'SF Pro Display',
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomePage(),
      ),
    );
  }
} 