import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:wordstock/model/folder/folder.dart';
import 'package:wordstock/pages/folder_page/folder_page_control.dart';
import 'package:wordstock/pages/folder_page/folder_registration.dart';

class FolderPage extends ConsumerWidget {
  const FolderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //共通プロバイダ
    final foldersProvider = ref.watch(folderProvider);
    //更新プロバイダ
    final controlFolderProvider = ref.read(folderProvider.notifier);

/*==============================================================================
【フォルダ画面】
==============================================================================*/
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'WordStock',
          style: TextStyle(color: Colors.white,),
        ),
        backgroundColor: Colors.black,
      ),
      body: SlidableAutoCloseBehavior(
        child: Padding(
          padding: EdgeInsets.only(top: 100.h),
          child: foldersProvider.when(
            data: (foldersProvider) => ListView.builder(
              itemCount: foldersProvider.length,
              itemBuilder: (context, index) {
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          //【編集画面】
                          Navigator.pushNamed(context, "/folderedit",
                              arguments: index);
                        },
                        backgroundColor: Colors.black,
                        icon: Icons.settings,
                        label: '編集',
                      ),
                      SlidableAction(
                        onPressed: (value) async {
                          //【削除処理】
                          final selectFolder = foldersProvider[index];
                          controlFolderProvider.deleteData(selectFolder, index);
                        },
                        backgroundColor: Colors.black,
                        icon: Icons.delete,
                        label: '削除',
                      ),
                    ],
                  ),
                  child: ListTile(
                    //【ListWidget処理】
                    title: _folderList(index, foldersProvider, context),
                  ),
                );
              },
            ),
            error: (error, stackTrace) =>
                Text('エラーが発生しました。\n ${error.toString()}'),
            loading: () => const CircularProgressIndicator(),
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 530.h),
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  //【登録画面】
                  return const FolderRegistration();
                });
          },
          child: const Icon(Icons.create_new_folder,
              color: Colors.black,),
        ),
      ),
    );
  }
}

/*==============================================================================
【ListWidget処理】
==============================================================================*/
Widget _folderList(int i, List<Folder> foldersProvider, BuildContext context) =>
    Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Container(
        height: 60.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.w)),
          color: Colors.white,
        ),
        child: Center(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                //【ワード画面】
                final String? folderIdNum = foldersProvider[i].id;
                Navigator.pushNamed(context, "/wordpage",
                    arguments: folderIdNum);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.folder,
                    size: 60.sp,
                    color: Colors.black,
                  ),
                  Text(
                    foldersProvider[i].name ?? '値が入っていません！',
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
