import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:peduli_kucing/features/map/domain/models/cat_marker.dart';
import 'package:peduli_kucing/features/map/domain/repositories/cat_marker_repository.dart';

class SupabaseCatMarkerRepository implements CatMarkerRepository {
  final SupabaseClient _client;

  SupabaseCatMarkerRepository(this._client);

  @override
  Future<List<CatMarker>> getMarkers() async {
    final response = await _client.from('cat_markers').select();
    return (response as List).map((json) => CatMarker.fromJson(json)).toList();
  }

  @override
  Future<CatMarker> addMarker(CatMarker marker) async {
    final response = await _client
        .from('cat_markers')
        .insert(marker.toJson())
        .select()
        .single();
    return CatMarker.fromJson(response);
  }

  @override
  Future<String> uploadImage(Uint8List bytes, String fileName) async {
    final storage = _client.storage.from('peduli_kucing');
    final filePath = 'cat_images/${DateTime.now().millisecondsSinceEpoch}_$fileName';
    await storage.uploadBinary(
      filePath, 
      bytes,
      fileOptions: const FileOptions(upsert: true),
    );
    return storage.getPublicUrl(filePath);
  }
}
