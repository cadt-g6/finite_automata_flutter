import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:finite_automata_flutter/models/fa_model.dart';
import 'package:finite_automata_flutter/screens/fa_detail_screen.dart';
import 'package:finite_automata_flutter/services/fa_cloud_service.dart';
import 'package:finite_automata_flutter/services/toast_service.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: const Text("Finite Automata"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
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
            onPressed: () {
              load();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: fas.length,
        itemBuilder: (context, index) {
          final fa = fas[index];
          return ListTile(
            title: Text("States: ${fa.states.join(",")}"),
            subtitle: Text("Symbols: ${fa.symbols.join(",")}"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return FaDetailScreen(faModel: fa);
                }),
              );
            },
            trailing: fa.firebaseDocumentId != null
                ? IconButton(
                    icon: const Icon(Icons.delete),
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
                  )
                : null,
          );
        },
      ),
    );
  }
}
