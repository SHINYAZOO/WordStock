import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordstock/domain/folder/folder.dart';
import 'package:wordstock/repository/sqlite_repository.dart';

final allFoldersProvider =
    FutureProvider((ref) => ref.read(sqliteRepositoryProvider).getFolders());

final folderProvider =
    StateNotifierProvider<FolderController, AsyncValue<List<Folder>>>((ref) {
  final sqliteRepo = ref.read(sqliteRepositoryProvider);
  final allFolders = ref.watch(allFoldersProvider);

  return FolderController(sqliteRepo, allFolders);
});

class FolderController extends StateNotifier<AsyncValue<List<Folder>>> {
  FolderController(this.sqliteRepo, this.allFolders) : super(allFolders);

  final SqliteRepository sqliteRepo;
  final AsyncValue<List<Folder>> allFolders;

  Future<void> registerData(Folder register) async {
    await sqliteRepo.registerFolder(register);
    state = state.value != null
        ? AsyncValue.data([...?state.value, register])
        : const AsyncValue.data([]);
  }

  Future<void> deleteData(Folder selectFolder, int index) async {
    if (selectFolder.id == null) return;
    await sqliteRepo.deleteFolder(selectFolder.id);
    await sqliteRepo.deleteIdSearch(selectFolder.id);
    if (state.value == null) return;
    state = AsyncValue.data(state.value!..remove(selectFolder));
  }

  Future<void> upData(int index, String dataText) async {
    if (state.value == null) return;
    state.value![index] = state.value![index].copyWith(name: dataText);
    await sqliteRepo.upFolder(state.value![index]);
    state = AsyncValue.data([...state.value!]);
  }
}
