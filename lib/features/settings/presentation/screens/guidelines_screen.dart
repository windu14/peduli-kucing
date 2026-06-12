import 'package:flutter/material.dart';
import 'package:peduli_kucing/core/theme/app_colors.dart';

class GuidelinesScreen extends StatelessWidget {
  const GuidelinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pedoman Komunitas'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.darkNavy,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.softYellow.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.brightOrange.withValues(alpha: 0.5), width: 2),
              ),
              child: Column(
                children: [
                  const Icon(Icons.warning_rounded, color: AppColors.brightOrange, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Penting untuk Dibaca!',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkNavy,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Demi kenyamanan bersama, seluruh pengguna wajib mematuhi pedoman komunitas berikut. Pelanggaran dapat mengakibatkan akun Anda dibanned permanen.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildGuidelineItem(
              context,
              icon: Icons.pets,
              title: '1. Khusus Untuk Kucing',
              description: 'Aplikasi ini didedikasikan khusus untuk pelaporan dan pemantauan kucing. Dilarang mengunggah foto hewan lain atau objek yang tidak berkaitan dengan kucing.',
            ),
            const SizedBox(height: 16),
            _buildGuidelineItem(
              context,
              icon: Icons.no_photography_rounded,
              title: '2. Dilarang Upload Konten NSFW',
              description: 'Dilarang keras mengunggah foto atau deskripsi yang mengandung unsur NSFW (Not Safe For Work), kekerasan ekstrem, atau hal-hal tidak senonoh lainnya.',
            ),
            const SizedBox(height: 16),
            _buildGuidelineItem(
              context,
              icon: Icons.block_flipped,
              title: '3. Dilarang Spam',
              description: 'Dilarang membuat pin atau marker palsu (spam) di peta yang tidak sesuai dengan keberadaan kucing yang sebenarnya. Pastikan lokasi yang Anda laporkan valid.',
            ),
            const SizedBox(height: 16),
            _buildGuidelineItem(
              context,
              icon: Icons.favorite_rounded,
              title: '4. Saling Menghargai',
              description: 'Jaga bahasa dan perilaku Anda di dalam catatan dan deskripsi. Mari ciptakan komunitas pecinta kucing yang suportif dan damai.',
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.electricBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  'Saya Mengerti & Setuju',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuidelineItem(BuildContext context, {required IconData icon, required String title, required String description}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkNavy.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.electricBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.electricBlue, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
