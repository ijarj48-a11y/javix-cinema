import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifikasi')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Card(
            color: AppTheme.surface,
            child: ListTile(
              leading: Icon(Icons.movie_filter_rounded, color: AppTheme.primaryBright),
              title: Text('Javix Cinema siap digunakan'),
              subtitle: Text('Fondasi aplikasi sudah aktif. Katalog film akan ditambahkan bertahap.', style: TextStyle(color: AppTheme.textMuted)),
            ),
          ),
        ],
      ),
    );
  }
}
