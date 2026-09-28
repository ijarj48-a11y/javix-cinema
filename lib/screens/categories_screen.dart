import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/cinematic_card.dart';
import 'movie_detail_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key, required this.movies});

  final List<MovieItem> movies;

  @override
  Widget build(BuildContext context) {
    final genres = movies.map((m) => m.genre).toSet().toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Kategori')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        children: genres.map((genre) {
          final items = movies.where((m) => m.genre == genre).toList();
          return Padding(
            padding: const EdgeInsets.only(bottom: 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(genre, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 210,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final movie = items[index];
                      return CinematicCard(
                        movie: movie,
                        compact: true,
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: movie))),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  const CategoryChip({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: onTap,
      label: Text(label),
      backgroundColor: AppTheme.surfaceSoft,
      side: BorderSide(color: AppTheme.primary.withValues(alpha: 0.15)),
    );
  }
}
