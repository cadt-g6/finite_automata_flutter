import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:finite_automata_flutter/models/fa_model.dart';
import 'package:finite_automata_flutter/screens/fa_detail_screen.dart';
import 'package:finite_automata_flutter/services/fa_cloud_service.dart';
import 'package:finite_automata_flutter/services/toast_service.dart';
import 'package:finite_automata_flutter/widgets/fa_popup_menu_button.dart';
import 'package:finite_automata_flutter/widgets/fa_toggle_theme_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<FaModel> fas = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final result = await FaCloudService().fetchAll();
    if (result != null) {
      setState(() {
        fas = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return ListView.builder(
      itemCount: fas.length,
      itemBuilder: (context, index) {
        final fa = fas[index];
        return buildFaItem(context, fa);
      },
    );
  }

  Widget buildFaItem(BuildContext context, FaModel fa) {
    return FaPopupMenuButton(
      dxGetter: (dx) => dx + MediaQuery.of(context).size.width,
      items: (context) => buildFaTileOptions(context, fa),
      builder: (callback) {
        return ListTile(
          trailing: IconButton(icon: const Icon(Icons.more_vert), onPressed: callback),
          title: Text(fa.title ?? "NA"),
          isThreeLine: true,
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("States: ${fa.states.join(",")}. Symbols: ${fa.symbols.join(",")}"),
            ],
          ),
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return FaDetailScreen(faModel: fa);
              }),
            );
            load();
          },
        );
      },
    );
  }

  List<FaPopMenuItem> buildFaTileOptions(BuildContext context, FaModel fa) {
    return [
      FaPopMenuItem(
        title: "Open Editor",
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return FaDetailScreen(faModel: fa);
            }),
          );
        },
      ),
      FaPopMenuItem(
        title: "View in JSON",
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("DocID: ${fa.firebaseDocumentId}"),
                content: JsonViewer(fa.toJson()),
              );
            },
          );
        },
      ),
      if (fa.firebaseDocumentId != null)
        FaPopMenuItem(
          title: "Delete",
          titleStyle: TextStyle(color: Theme.of(context).colorScheme.error),
          onPressed: () async {
            final result = await showOkCancelAlertDialog(
              context: context,
              title: "Are you sure to delete?",
              message: "You can't undo this action.",
              isDestructiveAction: true,
            );
            switch (result) {
              case OkCancelResult.ok:
                await FaCloudService().delete(id: fa.firebaseDocumentId!);
                await load();
                ToastService.showSnackbar(
                  context: context,
                  title: "Deleted * docID: ${fa.firebaseDocumentId!}",
                );
                break;
              case OkCancelResult.cancel:
                break;
            }
          },
        ),
    ];
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Finite Automata"),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          tooltip: "Add new FA",
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return const FaDetailScreen();
              },
            ));
          },
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: "Reload list",
          onPressed: () {
            load();
          },
        ),
        FaToggleThemeButton(),
      ],
    );
  }
}
