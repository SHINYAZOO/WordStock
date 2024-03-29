import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wordstock/presentation/pages/analysis_page/analysis_page.dart';
import 'package:wordstock/presentation/pages/folder_page/folder_edit_page.dart';
import 'package:wordstock/presentation/pages/folder_page/folder_page.dart';
import 'package:wordstock/presentation/pages/play_page/play_page.dart';
import 'package:wordstock/presentation/pages/play_page/play_result_page.dart';
import 'package:wordstock/presentation/pages/word_page/word_edit_page.dart';
import 'package:wordstock/presentation/pages/word_page/word_page.dart';
import 'package:wordstock/presentation/pages/word_page/word_registration_page.dart';
import 'package:wordstock/presentation/parts/wordstock_theme.dart.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(431, 732),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            routes: <String, WidgetBuilder>{
              '/': (BuildContext context) => const FolderPage(),
              '/folder_edit_page': (BuildContext context) =>
                  const FolderEditPage(),
              '/word_page': (BuildContext context) => const WordPage(),
              '/word_registration_page': (BuildContext context) =>
                  const WordRegistrationPage(),
              '/word_edit_page': (BuildContext context) => const WordEditPage(),
              '/play_page': (BuildContext context) => const PlayPage(),
              '/play_result_page': (BuildContext context) =>
                  const PlayResultPage(),
              '/analysis_screen': (BuildContext context) => const AnalysisPage(),
            },
            theme: WordStockTheme.light(),
          );
        });
  }
}
