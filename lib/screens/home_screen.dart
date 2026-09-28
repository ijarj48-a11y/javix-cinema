import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../theme/app_theme.dart';
import '../widgets/cinematic_card.dart';
import 'categories_screen.dart';
import 'films_screen.dart';
import 'movie_detail_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _search = TextEditingController();
  int _nav = 0;
  bool _loading = true;
  String? _error;
  List<MovieItem> _movies = [];

  static const api = 'http://127.0.0.1:3000';

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    try {
      final r = await http
          .get(Uri.parse('$api/api/movies'))
          .timeout(const Duration(seconds: 10));

      if (r.statusCode != 200) {
        throw Exception('HTTP ${r.statusCode}');
      }

      final raw = jsonDecode(r.body);
      final list = raw is List
          ? raw
          : raw['movies'] ?? raw['data'] ?? [];

      final movies = (list as List)
          .whereType<Map>()
          .map((m) {
            final g = m['genres'];
            final genre = g is List && g.isNotEmpty
                ? g.join(' • ')
                : (m['genre'] ?? 'Film').toString();

            return MovieItem(
              id: int.tryParse('${m['id']}') ?? 0,
              title: '${m['title'] ?? m['name'] ?? 'Tanpa Judul'}',
              genre: genre,
              year: int.tryParse('${m['year']}') ?? 0,
              rating: double.tryParse('${m['rating'] ?? 0}') ?? 0,
              description: '${m['description'] ?? 'Film pilihan Javix Cinema.'}',
              posterUrl: '${m['poster'] ?? m['posterUrl'] ?? m['poster_url'] ?? ''}',
              streamUrl: '${m['streamUrl'] ?? m['stream_url'] ?? ''}',
            );
          })
          .toList();

      if (!mounted) return;
      setState(() {
        _movies = movies;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = '$e';
      });
    }
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _openSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FilmsScreen(
          movies: _movies,
          initialQuery: _search.text.trim(),
        ),
      ),
    );
  }

  void _selectNav(int i) {
    setState(() => _nav = i);
    if (i == 0) return;

    final page = switch (i) {
      1 => FilmsScreen(movies: _movies),
      2 => CategoriesScreen(movies: _movies),
      _ => const ProfileScreen(),
    };

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    ).then((_) {
      if (mounted) setState(() => _nav = 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadMovies,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 100),
            children: [
              _topBar(),
              const SizedBox(height: 20),
              _searchBar(),
              const SizedBox(height: 20),
              _hero(),
              const SizedBox(height: 25),
              _title('Trending sekarang'),
              const SizedBox(height: 10),
              _movieList(),
              const SizedBox(height: 25),
              _title('Genre'),
              const SizedBox(height: 10),
              _genres(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _nav,
        onDestinationSelected: _selectNav,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_movies_outlined),
            selectedIcon: Icon(Icons.local_movies),
            label: 'Film',
          ),
          NavigationDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category),
            label: 'Kategori',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _movieList() {
    if (_loading) {
      return const SizedBox(
        height: 220,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Column(
        children: [
          const Icon(Icons.cloud_off_rounded, size: 40),
          const SizedBox(height: 8),
          Text(
            'Gagal mengambil film',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _loadMovies,
            icon: const Icon(Icons.refresh),
            label: const Text('Coba lagi'),
          ),
        ],
      );
    }

    if (_movies.isEmpty) {
      return const SizedBox(
        height: 120,
        child: Center(
          child: Text(
            'Belum ada film di API.',
            style: TextStyle(color: AppTheme.textMuted),
          ),
        ),
      );
    }

    return SizedBox(
      height: 250,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _movies.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (_, i) {
          final movie = _movies[i];

          return CinematicCard(
            movie: movie,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MovieDetailScreen(movie: movie),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _topBar() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.asset(
            'assets/images/javix_logo.png',
            width: 52,
            height: 52,
          ),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'JAVIX',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.5,
              ),
            ),
            Text(
              'CINEMA',
              style: TextStyle(
                color: AppTheme.primaryBright,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const NotificationsScreen(),
            ),
          ),
          icon: const Icon(Icons.notifications_none_rounded),
        ),
      ],
    );
  }

  Widget _searchBar() {
    return TextField(
      controller: _search,
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => _openSearch(),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search_rounded),
        hintText: 'Cari film, aktor, atau genre...',
        suffixIcon: IconButton(
          onPressed: _openSearch,
          icon: const Icon(Icons.arrow_forward_rounded),
        ),
      ),
    );
  }

  Widget _hero() {
    return Container(
      height: 235,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF16415F),
            Color(0xFF07111F),
            Color(0xFF050A14),
          ],
        ),
        border: Border.all(
          color: AppTheme.primary.withValues(alpha: .22),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            'JAVIX CINEMA',
            style: TextStyle(
              color: AppTheme.primaryBright,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your next movie night\nstarts here.',
            style: TextStyle(
              fontSize: 27,
              height: 1.08,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FilmsScreen(movies: _movies),
              ),
            ),
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Explore films'),
          ),
        ],
      ),
    );
  }

  Widget _title(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FilmsScreen(movies: _movies),
            ),
          ),
          child: const Text('Lihat semua'),
        ),
      ],
    );
  }

  Widget _genres() {
    final genres = <String>{};

    for (final movie in _movies) {
      genres.addAll(
        movie.genre
            .split(' • ')
            .where((g) => g.trim().isNotEmpty),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: genres.map((genre) {
        return ActionChip(
          label: Text(genre),
          backgroundColor: AppTheme.surfaceSoft,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FilmsScreen(
                movies: _movies,
                initialQuery: genre,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
