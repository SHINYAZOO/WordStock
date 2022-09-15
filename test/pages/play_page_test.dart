import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wordstock/app.dart';
import 'package:wordstock/repository/sqlite_repository.dart';

import '../repository/dummy_repository.dart';

final _testApp = ProviderScope(
  overrides: [sqliteRepositoryProvider.overrideWithValue(DummyRepository())],
  child: const App(),
);

void playPageTest() {
  group('PLAY画面', () {
    testWidgets('PLAY画面の表示（BADボタン押下）', (WidgetTester tester) async {
      await tester.pumpWidget(_testApp);

      // フォルダ作成
      await tester.pump();
      expect(find.byIcon(Icons.folder), findsNothing);
      await tester.tap(find.byIcon(Icons.create_new_folder));
      await tester.pump();
      await tester.tap(find.text('OK'));
      await tester.pump();
      await tester.pump();
      expect(find.byIcon(Icons.folder), findsOneWidget);

      // word画面遷移
      await tester.tap(find.byIcon(Icons.folder));

      // 再描画
      await tester.pump();
      await tester.pump();

      // TEST画面遷移
      await tester.tap(find.text('TEST開始'));
      await tester.pumpAndSettle();

      // Play画面　1フレーム目
      expect(find.byIcon(Icons.highlight_off), findsOneWidget);
      expect(find.text('frontName'), findsOneWidget);
      expect(find.text('backName'), findsOneWidget);
      expect(find.byIcon(Icons.thumb_down_alt), findsOneWidget);
      expect(find.byIcon(Icons.thumb_up_alt), findsOneWidget);

      // BADボタン押下
      await tester.tap(find.byIcon(Icons.thumb_down_alt));
      await tester.pumpAndSettle();

      // 成績表画面遷移の為非表示になる 2フレーム目
      expect(find.byIcon(Icons.highlight_off), findsNothing);
      expect(find.text('frontName'), findsNothing);
      expect(find.text('backName'), findsNothing);
      expect(find.byIcon(Icons.thumb_down_alt), findsNothing);
      expect(find.byIcon(Icons.thumb_up_alt), findsNothing);
    });

    testWidgets('PLAY画面の表示（GOODボタン押下）', (WidgetTester tester) async {
      await tester.pumpWidget(_testApp);

      // フォルダ作成
      await tester.pump();
      expect(find.byIcon(Icons.folder), findsNothing);
      await tester.tap(find.byIcon(Icons.create_new_folder));
      await tester.pump();
      await tester.tap(find.text('OK'));
      await tester.pump();
      await tester.pump();
      expect(find.byIcon(Icons.folder), findsOneWidget);

      // word画面遷移
      await tester.tap(find.byIcon(Icons.folder));

      // 再描画
      await tester.pump();
      await tester.pump();

      // TEST画面遷移
      await tester.tap(find.text('TEST開始'));
      await tester.pumpAndSettle();

      // Play画面　1フレーム目
      expect(find.byIcon(Icons.highlight_off), findsOneWidget);
      expect(find.text('frontName'), findsOneWidget);
      expect(find.text('backName'), findsOneWidget);
      expect(find.byIcon(Icons.thumb_down_alt), findsOneWidget);
      expect(find.byIcon(Icons.thumb_up_alt), findsOneWidget);

      // GOODボタン押下
      await tester.tap(find.byIcon(Icons.thumb_up_alt));
      await tester.pumpAndSettle();

      // 成績表画面遷移の為非表示になる 2フレーム目
      expect(find.byIcon(Icons.highlight_off), findsNothing);
      expect(find.text('frontName'), findsNothing);
      expect(find.text('backName'), findsNothing);
      expect(find.byIcon(Icons.thumb_down_alt), findsNothing);
      expect(find.byIcon(Icons.thumb_up_alt), findsNothing);
    });

    testWidgets('PLAY画面の表示（成績表表示 BAD押下）', (WidgetTester tester) async {
      await tester.pumpWidget(_testApp);

      // フォルダ作成
      await tester.pump();
      expect(find.byIcon(Icons.folder), findsNothing);
      await tester.tap(find.byIcon(Icons.create_new_folder));
      await tester.pump();
      await tester.tap(find.text('OK'));
      await tester.pump();
      await tester.pump();
      expect(find.byIcon(Icons.folder), findsOneWidget);

      // word画面遷移
      await tester.tap(find.byIcon(Icons.folder));

      // 再描画
      await tester.pump();
      await tester.pump();

      // TEST画面遷移
      await tester.tap(find.text('TEST開始'));
      await tester.pumpAndSettle();

      // 1フレーム目
      expect(find.byIcon(Icons.highlight_off), findsOneWidget);
      expect(find.text('終了'), findsNothing);
      expect(find.text('間違えた箇所をもう一度'), findsNothing);
      expect(find.text('正解率：0%'), findsNothing);
      expect(find.text('問題数：1'), findsNothing);
      expect(find.text('正：0'), findsNothing);
      expect(find.text('誤：1'), findsNothing);

      // BADボタン押下
      await tester.tap(find.byIcon(Icons.thumb_down_alt));
      await tester.pumpAndSettle();

      // 成績表表示画面 2フレーム目
      expect(find.byIcon(Icons.highlight_off), findsNothing);
      expect(find.text('終了'), findsOneWidget);
      expect(find.text('間違えた箇所をもう一度'), findsOneWidget);
      expect(find.text('正解率：0%'), findsOneWidget);
      expect(find.text('問題数：1'), findsOneWidget);
      expect(find.text('正：0'), findsOneWidget);
      expect(find.text('誤：1'), findsOneWidget);
    });

    testWidgets('PLAY画面の表示（成績表表示 GOOD押下）', (WidgetTester tester) async {
      await tester.pumpWidget(_testApp);

      // フォルダ作成
      await tester.pump();
      expect(find.byIcon(Icons.folder), findsNothing);
      await tester.tap(find.byIcon(Icons.create_new_folder));
      await tester.pump();
      await tester.tap(find.text('OK'));
      await tester.pump();
      await tester.pump();
      expect(find.byIcon(Icons.folder), findsOneWidget);

      // word画面遷移
      await tester.tap(find.byIcon(Icons.folder));

      // 再描画
      await tester.pump();
      await tester.pump();

      // TEST画面遷移
      await tester.tap(find.text('TEST開始'));
      await tester.pumpAndSettle();

      // 1フレーム目
      expect(find.byIcon(Icons.highlight_off), findsOneWidget);
      expect(find.text('終了'), findsNothing);
      expect(find.text('間違えた箇所をもう一度'), findsNothing);
      expect(find.text('正解率：0%'), findsNothing);
      expect(find.text('問題数：1'), findsNothing);
      expect(find.text('正：0'), findsNothing);
      expect(find.text('誤：1'), findsNothing);

      // GOODボタン押下
      await tester.tap(find.byIcon(Icons.thumb_up_alt));
      await tester.pumpAndSettle();

      // 成績表表示画面 2フレーム目
      expect(find.byIcon(Icons.highlight_off), findsNothing);
      expect(find.text('終了'), findsOneWidget);
      expect(find.text('間違えた箇所をもう一度'), findsNothing);
      expect(find.text('正解率：100%'), findsOneWidget);
      expect(find.text('問題数：1'), findsOneWidget);
      expect(find.text('正：1'), findsOneWidget);
      expect(find.text('誤：0'), findsOneWidget);
    });

    testWidgets('単語削除画面', (WidgetTester tester) async {
      await tester.pumpWidget(_testApp);

      // フォルダ作成
      await tester.pump();
      expect(find.byIcon(Icons.folder), findsNothing);
      await tester.tap(find.byIcon(Icons.create_new_folder));
      await tester.pump();
      await tester.tap(find.text('OK'));
      await tester.pump();
      await tester.pump();
      expect(find.byIcon(Icons.folder), findsOneWidget);

      // word画面遷移
      await tester.tap(find.byIcon(Icons.folder));

      // 再描画
      await tester.pump();
      await tester.pump();

      // Listスライド
      await tester.drag(
          find.byIcon(Icons.description), const Offset(-500.0, 0.0));
      await tester.pumpAndSettle();

      // 1ケース目
      expect(find.byIcon(Icons.description), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);

      // 再描画
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // 2ケース目
      expect(find.byIcon(Icons.description), findsNothing);
      expect(find.byIcon(Icons.settings), findsNothing);
      expect(find.byIcon(Icons.delete), findsNothing);
    });
  });
}
