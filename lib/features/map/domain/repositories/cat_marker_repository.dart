import 'dart:typed_data';
import '../models/cat_marker.dart';

abstract class CatMarkerRepository {
  Future<List<CatMarker>> getMarkers();
  Future<CatMarker> addMarker(CatMarker marker);
  Future<String> uploadImage(Uint8List bytes, String fileName);
}
