import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peduli_kucing/core/theme/app_colors.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
class AddCatDialog extends StatefulWidget {
  final Function(String emote, String kondisi, String jenis, String deskripsi, Uint8List? imageBytes, String? imageExt) onSubmit;

  const AddCatDialog({super.key, required this.onSubmit});

  @override
  State<AddCatDialog> createState() => _AddCatDialogState();
}

class _AddCatDialogState extends State<AddCatDialog> {
  String? _selectedEmote;
  String _selectedKondisi = 'Sehat';
  String _selectedJenis = 'Lokal';
  final TextEditingController _deskripsiController = TextEditingController();
  XFile? _selectedImage;
  bool _isSubmitting = false;

  final List<String> emotes = ['😺', '😻', '😼', '😿', '😾', '😽'];
  final List<String> kondisiList = ['Sehat', 'Sakit', 'Cacat', 'Tanpa Rumah', 'Butuh Makan'];

  @override
  void dispose() {
    _deskripsiController.dispose();
    super.dispose();
  }

  Uint8List? _imageBytes;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 800,
    );
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _selectedImage = image;
        _imageBytes = bytes;
      });
    }
  }

  Future<void> _submit() async {
    if (_selectedEmote == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih emote terlebih dahulu!')),
      );
      return;
    }
    
    setState(() {
      _isSubmitting = true;
    });

    Uint8List? bytes;
    String? ext;
    if (_selectedImage != null && _imageBytes != null) {
      bytes = _imageBytes;
      ext = _selectedImage!.name.split('.').last;
    }

    widget.onSubmit(
      _selectedEmote!,
      _selectedKondisi,
      _selectedJenis,
      _deskripsiController.text.trim(),
      bytes,
      ext,
    );
    
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      backgroundColor: AppColors.surfaceContainerLowest,
      elevation: 0,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Kucing Terlihat!',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Beritahu kami lebih lanjut tentang teman ini',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Emotes
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: emotes.map((emote) {
                  final isSelected = _selectedEmote == emote;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedEmote = emote;
                      });
                    },
                    borderRadius: BorderRadius.circular(9999),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? AppColors.brightOrange.withValues(alpha: 0.2)
                            : AppColors.softYellow.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: isSelected 
                            ? Border.all(color: AppColors.brightOrange, width: 2)
                            : null,
                      ),
                      child: Text(
                        emote,
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              // Kondisi Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedKondisi,
                decoration: InputDecoration(
                  labelText: 'Kondisi Kucing',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  filled: true,
                  fillColor: AppColors.surfaceContainerLowest,
                ),
                items: kondisiList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedKondisi = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Jenis Kucing Custom Toggle
              Text(
                'Jenis Kucing',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildJenisToggleButton('Lokal'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildJenisToggleButton('Ras'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Deskripsi
              TextField(
                controller: _deskripsiController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Deskripsi / Catatan Tambahan',
                  hintText: 'Contoh: Kucing berwarna belang tiga, terlihat lapar...',
                  hintStyle: TextStyle(color: AppColors.onSurfaceVariant.withValues(alpha: 0.5)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  filled: true,
                  fillColor: AppColors.surfaceContainerLowest,
                ),
              ),
              const SizedBox(height: 24),
              // Image Picker
              Text(
                'Foto Kucing (Opsional)',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickImage,
                borderRadius: BorderRadius.circular(16),
                child: DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    color: AppColors.outlineVariant,
                    strokeWidth: 2,
                    dashPattern: const [8, 4],
                    radius: const Radius.circular(16),
                    padding: EdgeInsets.zero,
                  ),
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: kIsWeb && _imageBytes != null
                                ? Image.memory(_imageBytes!, fit: BoxFit.cover, width: double.infinity)
                                : Image.file(File(_selectedImage!.path), fit: BoxFit.cover, width: double.infinity),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.add_a_photo_rounded, size: 32, color: AppColors.outlineVariant),
                              SizedBox(height: 8),
                              Text(
                                'Ketuk untuk unggah foto', 
                                textAlign: TextAlign.center, 
                                style: TextStyle(color: AppColors.onSurfaceVariant)
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '(Tips: maksimal upload gambar 50 MB)',
                style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  backgroundColor: AppColors.electricBlue,
                  foregroundColor: Colors.white,
                ),
                child: _isSubmitting 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Simpan Penanda'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Batal',
                  style: TextStyle(color: AppColors.onSurfaceVariant, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJenisToggleButton(String jenis) {
    final isSelected = _selectedJenis == jenis;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedJenis = jenis;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.brightOrange.withValues(alpha: 0.1)
              : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.brightOrange : AppColors.outlineVariant,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            jenis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? AppColors.brightOrange : AppColors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
