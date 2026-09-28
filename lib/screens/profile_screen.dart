import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
        children: [
          Center(
            child: Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: [AppTheme.primaryBright, AppTheme.primary]),
                boxShadow: const [BoxShadow(color: Color(0x5522C7FF), blurRadius: 30)],
              ),
              child: const Icon(Icons.person_rounded, color: Colors.black, size: 50),
            ),
          ),
          const SizedBox(height: 16),
          const Center(child: Text('Pengguna Javix', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900))),
          const SizedBox(height: 6),
          const Center(child: Text('Nikmati dan temukan film favoritmu.', style: TextStyle(color: AppTheme.textMuted))),
          const SizedBox(height: 28),
          _tile(context, Icons.bookmark_outline_rounded, 'Daftar tersimpan', 'Film yang kamu simpan', () => _info(context, 'Daftar tersimpan masih kosong.')),
          _tile(context, Icons.history_rounded, 'Riwayat', 'Aktivitas tontonan', () => _info(context, 'Riwayat tontonan belum tersedia.')),
          _tile(context, Icons.settings_outlined, 'Pengaturan', 'Preferensi aplikasi', () => _info(context, 'Pengaturan akan ditambahkan bertahap.')),
          _tile(context, Icons.info_outline_rounded, 'Tentang Javix Cinema', 'Versi 0.2', () => showAboutDialog(context: context, applicationName: 'Javix Cinema', applicationVersion: '0.2.0', applicationLegalese: 'Javix Cinema')),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Card(
      color: AppTheme.surface,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppTheme.primaryBright),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle, style: const TextStyle(color: AppTheme.textMuted)),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }

  void _info(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
