import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'helpers/database_helper.dart';
import 'providers/pemesanan_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.initDb();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => PemesananProvider())],
      child: MaterialApp(
        title: 'Krui Homestay',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.teal, useMaterial3: true),
        home: const SplashScreen(),
      ),
    );
  }
}
