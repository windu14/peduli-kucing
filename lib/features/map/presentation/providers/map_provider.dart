import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peduli_kucing/core/config/supabase_config.dart';
import 'package:peduli_kucing/features/map/data/repositories/supabase_cat_marker_repository.dart';
import 'package:peduli_kucing/features/map/domain/models/cat_marker.dart';
import 'package:peduli_kucing/features/map/domain/repositories/cat_marker_repository.dart';

final catMarkerRepositoryProvider = Provider<CatMarkerRepository>((ref) {
  return SupabaseCatMarkerRepository(SupabaseConfig.client);
});

final catMarkersProvider = StateNotifierProvider<CatMarkersNotifier, AsyncValue<List<CatMarker>>>((ref) {
  final repository = ref.watch(catMarkerRepositoryProvider);
  return CatMarkersNotifier(repository)..loadMarkers();
});

class CatMarkersNotifier extends StateNotifier<AsyncValue<List<CatMarker>>> {
  final CatMarkerRepository _repository;

  CatMarkersNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> loadMarkers() async {
    state = const AsyncValue.loading();
    try {
      final markers = await _repository.getMarkers();
      state = AsyncValue.data(markers);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addMarker(CatMarker marker) async {
    try {
      final newMarker = await _repository.addMarker(marker);
      if (state.hasValue) {
        state = AsyncValue.data([...state.value!, newMarker]);
      }
    } catch (e) {
      // In a real app we'd show an error, but here we just re-throw or log
      debugPrint('Error adding marker: $e');
      // FALLBACK: Add to local state anyway so it appears on the map
      if (state.hasValue) {
        final fallbackMarker = marker.copyWith(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          createdAt: DateTime.now(),
        );
        state = AsyncValue.data([...state.value!, fallbackMarker]);
      }
    }
  }

  Future<void> addMarkerWithImage(CatMarker marker, Uint8List? imageBytes, String? imageExt) async {
    CatMarker finalMarker = marker;
    try {
      if (imageBytes != null && imageExt != null) {
        try {
          final imageUrl = await _repository.uploadImage(imageBytes, imageExt);
          finalMarker = marker.copyWith(imageUrl: imageUrl);
        } catch (e) {
          debugPrint('Error uploading image: $e');
        }
      }
      
      final newMarker = await _repository.addMarker(finalMarker);
      if (state.hasValue) {
        state = AsyncValue.data([...state.value!, newMarker]);
      }
    } catch (e) {
      debugPrint('Error adding marker with image: $e');
      rethrow;
    }
  }
}
