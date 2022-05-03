import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finite_automata_flutter/models/fa_model.dart';

class FaCloudService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference<Map<String, dynamic>> fasCollection;

  FaCloudService() {
    fasCollection = firestore.collection("fas");
  }

  Future<List<FaModel>?> fetchAll() async {
    QuerySnapshot<Map<String, dynamic>> result = await fasCollection.get();

    List<FaModel> fas = [];
    for (var doc in result.docs) {
      Map<String, dynamic> json = doc.data();
      FaModel fa = FaModel.fromJson(json);
      fa.firebaseDocumentId = doc.id;
      fas.add(fa);
    }

    return fas;
  }

  Future<FaModel?> create(FaModel faModel) async {
    DocumentReference<Map<String, dynamic>> result = await fasCollection.add(faModel.toJson());

    final data = await result.get();
    final json = data.data();
    if (json != null) {
      FaModel createdFa = FaModel.fromJson(json);
      createdFa.firebaseDocumentId = data.id;
      return createdFa;
    }

    return null;
  }

  Future<void> update({
    required FaModel faModel,
    required String id,
  }) async {
    return fasCollection.doc(id).update(faModel.toJson());
  }

  Future<void> delete({
    required String id,
  }) async {
    return fasCollection.doc(id).delete();
  }
}
