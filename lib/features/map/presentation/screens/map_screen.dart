import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:peduli_kucing/core/theme/app_colors.dart';
import 'package:peduli_kucing/features/map/domain/models/cat_marker.dart';
import 'package:peduli_kucing/features/map/presentation/providers/map_provider.dart';
import 'package:peduli_kucing/features/map/presentation/screens/cat_detail_screen.dart';
import 'package:peduli_kucing/features/map/presentation/widgets/add_cat_dialog.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController _mapController = MapController();
  // Default to Jakarta, Indonesia for now
  final LatLng _initialCenter = const LatLng(-6.200000, 106.816666);
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Layanan lokasi dinonaktifkan.')));
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Izin lokasi ditolak.')));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Izin lokasi ditolak secara permanen.')));
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    if (mounted) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
      _mapController.move(_currentLocation!, 15.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final markersState = ref.watch(catMarkersProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkNavy.withValues(alpha: 0.1),
                blurRadius: 24,
                spreadRadius: 0,
              )
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.pets, color: AppColors.brightOrange),
              const SizedBox(width: 8),
              Text(
                'Peduli Kucing',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.brightOrange,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _initialCenter,
          initialZoom: 13.0,
          onTap: (tapPosition, point) => _showAddCatDialog(context, point),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.peduli_kucing',
          ),
          markersState.when(
            data: (markers) {
              final mapMarkers = markers.map((catMarker) {
                return Marker(
                  point: LatLng(catMarker.latitude, catMarker.longitude),
                  width: 60,
                  height: 60,
                  child: GestureDetector(
                    onTap: () => _showCatDetails(context, catMarker),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            blurRadius: 12,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          catMarker.emote,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList();

              return MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  maxClusterRadius: 45,
                  size: const Size(50, 50),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(50),
                  maxZoom: 15,
                  markers: mapMarkers,
                  builder: (context, markers) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.brightOrange,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.brightOrange.withValues(alpha: 0.4),
                            blurRadius: 12,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          markers.length.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
          if (_currentLocation != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: _currentLocation!,
                  width: 30,
                  height: 30,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.electricBlue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.electricBlue.withValues(alpha: 0.5),
                          blurRadius: 12,
                          spreadRadius: 4,
                        )
                      ]
                    ),
                  ),
                )
              ],
            ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 96.0, right: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'btn_gps',
              onPressed: _getCurrentLocation,
              backgroundColor: Colors.white,
              foregroundColor: AppColors.electricBlue,
              child: const Icon(Icons.my_location),
            ),
            const SizedBox(height: 16),
            FloatingActionButton.extended(
              heroTag: 'btn_add',
              onPressed: () {
                _showAddCatDialog(context, _mapController.camera.center);
              },
              icon: const Icon(Icons.add_location_alt),
              label: const Text('Lapor Kucing!'),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  String _truncateWords(String text, int maxWords) {
    if (text.isEmpty) return text;
    final words = text.trim().split(RegExp(r'\s+'));
    if (words.length <= maxWords) return text;
    return '${words.take(maxWords).join(' ')}...';
  }

  void _showAddCatDialog(BuildContext context, LatLng point) {
    showDialog(
      context: context,
      builder: (context) {
        return AddCatDialog(
          onSubmit: (emote, kondisi, jenis, deskripsi, imageBytes, imageExt) {
            final marker = CatMarker(
              latitude: point.latitude,
              longitude: point.longitude,
              emote: emote,
              kondisi: kondisi,
              jenis: jenis,
              deskripsi: deskripsi,
              createdAt: DateTime.now(),
            );
            ref.read(catMarkersProvider.notifier).addMarkerWithImage(marker, imageBytes, imageExt);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Kucing dilaporkan! Terima kasih atas kepedulian Anda.'),
                backgroundColor: AppColors.mintGreen,
              ),
            );
          },
        );
      },
    );
  }

  void _showCatDetails(BuildContext context, CatMarker marker) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.softYellow.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      marker.emote,
                      style: const TextStyle(fontSize: 48),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detail Kucing',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${marker.jenis} • ${marker.kondisi}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.brightOrange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (marker.deskripsi.isNotEmpty) ...[
                Text(
                  'Catatan',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _truncateWords(marker.deskripsi, 25),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: 24),
              ],
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close modal
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CatDetailScreen(marker: marker),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.electricBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Lihat Detil Lengkap'),
                ),
              ),
            ],
          ),
          ),
        );
      },
    );
  }
}
