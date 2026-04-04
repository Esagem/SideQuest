import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

/// Service for uploading proof media to Firebase Storage.
///
/// Handles image compression and provides upload progress callbacks.
/// Files are stored at `proofs/{userId}/{questId}/{timestamp}.{ext}`.
class StorageService {
  /// Creates a [StorageService].
  StorageService(this._storage);

  final FirebaseStorage _storage;

  /// Uploads an image file and returns its download URL.
  ///
  /// [onProgress] is called with upload progress (0.0 to 1.0).
  Future<String> uploadProofImage({
    required String userId,
    required String questId,
    required File file,
    ValueChanged<double>? onProgress,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final ext = file.path.split('.').last;
    final ref = _storage.ref('proofs/$userId/$questId/$timestamp.$ext');

    final task = ref.putFile(
      file,
      SettableMetadata(contentType: 'image/$ext'),
    );

    if (onProgress != null) {
      task.snapshotEvents.listen((snap) {
        if (snap.totalBytes > 0) {
          onProgress(snap.bytesTransferred / snap.totalBytes);
        }
      });
    }

    await task;
    return ref.getDownloadURL();
  }

  /// Uploads a video file and returns its download URL.
  ///
  /// Only available for Pro users. [onProgress] reports upload progress.
  Future<String> uploadProofVideo({
    required String userId,
    required String questId,
    required File file,
    ValueChanged<double>? onProgress,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final ref = _storage.ref('proofs/$userId/$questId/$timestamp.mp4');

    final task = ref.putFile(
      file,
      SettableMetadata(contentType: 'video/mp4'),
    );

    if (onProgress != null) {
      task.snapshotEvents.listen((snap) {
        if (snap.totalBytes > 0) {
          onProgress(snap.bytesTransferred / snap.totalBytes);
        }
      });
    }

    await task;
    return ref.getDownloadURL();
  }
}
