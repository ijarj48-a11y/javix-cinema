import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/cinematic_card.dart';
import 'player_screen.dart';
import 'player_screen.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({super.key, required this.movie});

  final MovieItem movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Film')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        children: [
          Container(
            height: 320,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF18557A), Color(0xFF050A14)],
              ),
            ),
            child: const Center(child: Icon(Icons.movie_creation_outlined, size: 82, color: AppTheme.primaryBright)),
          ),
          const SizedBox(height: 22),
          Text(movie.title, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _pill('${movie.year}'),
              _pill(movie.genre),
              _pill('⭐ ${movie.rating.toStringAsFixed(1)}'),
            ],
          ),
          const SizedBox(height: 20),
          Text(movie.description, style: const TextStyle(color: AppTheme.textMuted, height: 1.5, fontSize: 15)),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => _showComingSoon(context),
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Tonton secara legal'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => _showComingSoon(context),
            icon: const Icon(Icons.bookmark_border_rounded),
            label: const Text('Simpan ke daftar'),
          ),
        ],
      ),
    );
  }

  Widget _pill(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(color: AppTheme.surfaceSoft, borderRadius: BorderRadius.circular(12)),
        child: Text(text, style: const TextStyle(fontSize: 12)),
      );

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fitur streaming akan dihubungkan ke sumber legal pada tahap berikutnya.')),
    );
  }
}
