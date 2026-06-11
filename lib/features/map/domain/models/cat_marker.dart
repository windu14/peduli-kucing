class CatMarker {
  final String? id;
  final double latitude;
  final double longitude;
  final String emote;
  final String kondisi;
  final String jenis;
  final String deskripsi;
  final String? imageUrl;
  final String? username;
  final DateTime? createdAt;

  CatMarker({
    this.id,
    required this.latitude,
    required this.longitude,
    required this.emote,
    this.kondisi = 'Sehat',
    this.jenis = 'Lokal',
    this.deskripsi = '',
    this.imageUrl,
    this.username,
    this.createdAt,
  });

  factory CatMarker.fromJson(Map<String, dynamic> json) {
    return CatMarker(
      id: json['id'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      emote: json['emote'] as String,
      kondisi: json['kondisi'] as String? ?? 'Sehat',
      jenis: json['jenis'] as String? ?? 'Lokal',
      deskripsi: json['deskripsi'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      username: json['username'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'emote': emote,
      'kondisi': kondisi,
      'jenis': jenis,
      'deskripsi': deskripsi,
      if (imageUrl != null) 'image_url': imageUrl,
      if (username != null) 'username': username,
      if (createdAt != null) 'created_at': createdAt?.toIso8601String(),
    };
  }

  CatMarker copyWith({
    String? id,
    double? latitude,
    double? longitude,
    String? emote,
    String? kondisi,
    String? jenis,
    String? deskripsi,
    String? imageUrl,
    String? username,
    DateTime? createdAt,
  }) {
    return CatMarker(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      emote: emote ?? this.emote,
      kondisi: kondisi ?? this.kondisi,
      jenis: jenis ?? this.jenis,
      deskripsi: deskripsi ?? this.deskripsi,
      imageUrl: imageUrl ?? this.imageUrl,
      username: username ?? this.username,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
