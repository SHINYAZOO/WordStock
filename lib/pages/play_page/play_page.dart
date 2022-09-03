import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:wordstock/model/word/word.dart';
import 'package:wordstock/pages/play_page/play_page_controller.dart';

class PlayPage extends ConsumerWidget {
  const PlayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final word = ModalRoute.of(context)?.settings.arguments;
    final words = word as List<Word>;

    ref.watch(playsProvider(words));

    final playCtr = ref.read(playsProvider(words).notifier);

/*==============================================================================
【プレイ画面】
==============================================================================*/
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('PLAY'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 350.h,
            child: SwipeCards(
                matchEngine: playCtr.matchEngine,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right: 15.w,
                      top: 10.h,
                    ),
                    child: _buildFlipCard(index, words),
                  );
                },
                //全カードスワイプ後の処理
                onStackFinished: () async {
                  await Navigator.of(context).pushNamedAndRemoveUntil(
                      "/play_result_page", ModalRoute.withName("/"),
                      arguments: words[0].folderNameId);
                }),
          ),
          _buildButton(words),
        ],
      ),
    );
  }
}

/*==============================================================================
【フリップカード処理】
==============================================================================*/
Widget _buildFlipCard(int index, List<Word> words) {
  return Consumer(builder: (context, ref, _) {
    ref.watch(playsProvider(words));
    final playCtr = ref.read(playsProvider(words).notifier);

    return FlipCard(
      direction: FlipDirection.VERTICAL,
      speed: 500,
      front: Card(
        margin: EdgeInsets.only(top: 10.h, right: 0.w, bottom: 0.h, left: 15.w),
        child: SizedBox(
          width: 380.w,
          child: Center(
              child: Text(
                  playCtr.matchEngine.currentItem?.content[index].frontName ??
                      '表示中にエラーが発生しました')),
        ),
      ),
      back: Card(
        margin: EdgeInsets.only(top: 10.h, right: 0.w, bottom: 0.h, left: 15.w),
        child: SizedBox(
          width: 380.w,
          child: Center(
            child: Text(
                playCtr.matchEngine.currentItem?.content[index].backName ??
                    '表示中にエラーが発生しました'),
          ),
        ),
      ),
    );
  });
}

/*==============================================================================
【GOOD/BAD ボタン処理】
==============================================================================*/
Widget _buildButton(List<Word> words) {
  return Consumer(builder: (context, ref, _) {
    ref.watch(playsProvider(words));

    final playCtr = ref.read(playsProvider(words).notifier);

    return Padding(
      padding: EdgeInsets.only(top: 40.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 120.w,
            height: 100.h,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: const BorderSide(color: Colors.blue),
              ),
              onPressed: () {
                playCtr.nope();
              },
              child: const Icon(
                Icons.thumb_down_alt,
              ),
            ),
          ),
          SizedBox(
            width: 120.w,
            height: 100.h,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: const BorderSide(color: Colors.blue),
              ),
              onPressed: () {
                playCtr.like();
              },
              child: const Icon(
                Icons.thumb_up_alt,
              ),
            ),
          ),
        ],
      ),
    );
  });
}
