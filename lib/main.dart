import 'package:flutter/material.dart';
import 'package:next_todo/presentation/screen/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next_todo/infrastructure/API/todo_repository_impl.dart';
import 'package:next_todo/application/state/providers/todo_repository_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ja'); //intlパッケージは日本語の日時フォーマットに設定
  Intl.defaultLocale = 'ja'; // 日付・数値フォーマットのデフォルトを日本語に設定

  runApp(
    ProviderScope(
      overrides: [
        todoRepositoryProvider.overrideWithValue(TodoRepositoryImpl()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // デバッグバナーを消す
      locale: const Locale('ja'), // アプリの言語を日本語に固定
      supportedLocales: const [Locale('ja'), Locale('en')], //日本語と英語をサポート
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const HomeScreen(),
    );
  }
}
