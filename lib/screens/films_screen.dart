import 'package:flutter/material.dart';

import '../widgets/cinematic_card.dart';
import 'movie_detail_screen.dart';

class FilmsScreen extends StatelessWidget {
  const FilmsScreen({super.key, required this.movies, this.initialQuery = ''});

  final List<MovieItem> movies;
  final String initialQuery;

  @override
  Widget build(BuildContext context) {
    final query = initialQuery.trim().toLowerCase();
    final filtered = query.isEmpty
        ? movies
        : movies.where((m) => '${m.title} ${m.genre} ${m.year}'.toLowerCase().contains(query)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Film')),
      body: filtered.isEmpty
          ? const Center(child: Text('Film tidak ditemukan.'))
          : GridView.builder(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
              itemCount: filtered.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.70,
              ),
              itemBuilder: (context, index) {
                final movie = filtered[index];
                return CinematicCard(
                  movie: movie,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: movie))),
                );
              },
            ),
    );
  }
}
