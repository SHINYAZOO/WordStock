import 'package:wordstock/model/folder/folder.dart';
import 'package:wordstock/model/word/word.dart';

class DummyNotPlay {
  static List<Word> initialValue = [
    Word(
      id: null,
      frontName: null,
      backName: null,
      tableName: null,
      folderNameId: null,
      yesCount: null,
      noCount: null,
      play: null,
      time: null,
      percent: null,
      average: null,
      passed: null,
    )
  ];
  static List<Folder> initialFolderValue = [
    Folder(
      id: null,
      name: null,
      tableName: null,
    )
  ];
}