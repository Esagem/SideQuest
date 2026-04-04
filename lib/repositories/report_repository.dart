import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sidequest/models/report_model.dart';

/// Repository for content reports in Firestore.
///
/// Users can create reports; only moderators can read/update them
/// (enforced by Firestore security rules).
class ReportRepository {
  /// Creates a [ReportRepository].
  ReportRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<ReportModel> get _collection =>
      _firestore.collection('reports').withConverter<ReportModel>(
            fromFirestore: (snap, _) =>
                ReportModel.fromJson({...snap.data()!, 'id': snap.id}),
            toFirestore: (model, _) => model.toJson()..remove('id'),
          );

  /// Creates a new report.
  Future<String> create(ReportModel report) async {
    final doc = await _collection.add(report);
    return doc.id;
  }
}
