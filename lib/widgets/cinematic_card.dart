import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class MovieItem {
  const MovieItem({
    required this.title,
    required this.genre,
    required this.year,
    this.rating = 0.0,
    this.description = 'Film pilihan Javix Cinema.',
  });

  final String title;
  final String genre;
  final int year;
  final double rating;
  final String description;
}

class CinematicCard extends StatelessWidget {
  const CinematicCard({
    super.key,
    required this.movie,
    required this.onTap,
    this.compact = false,
  });

  final MovieItem movie;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: compact ? 150 : 174,
      child: Material(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF164E70), Color(0xFF07101D)],
                      ),
                    ),
                    child: Stack(
                      children: [
                        const Center(
                          child: Icon(Icons.movie_creation_outlined, size: 42, color: AppTheme.primaryBright),
                        ),
                        Positioned(
                          left: 9,
                          bottom: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.55),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('${movie.year}', style: const TextStyle(fontSize: 11)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  movie.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 14, color: AppTheme.primaryBright),
                    const SizedBox(width: 3),
                    Text(movie.rating.toStringAsFixed(1), style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(movie.genre, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
