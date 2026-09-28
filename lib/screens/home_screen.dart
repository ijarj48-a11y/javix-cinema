import 'package:flutter/material.dart';

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
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;

  final List<MovieItem> _movies = const [
    MovieItem(title: 'Midnight Run', genre: 'Action', year: 2026, rating: 8.4, description: 'Aksi malam penuh teka-teki dan kejar-kejaran.'),
    MovieItem(title: 'Blue Horizon', genre: 'Drama', year: 2026, rating: 8.1, description: 'Drama perjalanan tentang pilihan dan harapan.'),
    MovieItem(title: 'Last Signal', genre: 'Thriller', year: 2025, rating: 8.6, description: 'Sebuah sinyal misterius mengubah malam yang tenang.'),
    MovieItem(title: 'Summer Note', genre: 'Romance', year: 2025, rating: 7.9, description: 'Cerita ringan tentang kenangan musim panas.'),
    MovieItem(title: 'Wild City', genre: 'Action', year: 2025, rating: 8.0, description: 'Kota besar, misi besar, dan waktu yang terus berjalan.'),
    MovieItem(title: 'The Archive', genre: 'Thriller', year: 2024, rating: 8.3, description: 'Arsip lama menyimpan rahasia yang belum selesai.'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openSearch() {
    final query = _searchController.text.trim();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => FilmsScreen(movies: _movies, initialQuery: query)));
  }

  void _selectNav(int index) {
    setState(() => _selectedIndex = index);
    if (index == 0) return;
    final page = switch (index) {
      1 => FilmsScreen(movies: _movies),
      2 => CategoriesScreen(movies: _movies),
      _ => const ProfileScreen(),
    };
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page)).then((_) {
      if (mounted) setState(() => _selectedIndex = 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              sliver: SliverToBoxAdapter(child: _topBar()),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              sliver: SliverToBoxAdapter(child: _searchBar()),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              sliver: SliverToBoxAdapter(child: _hero()),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
              sliver: SliverToBoxAdapter(child: _sectionTitle('Trending sekarang', () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => FilmsScreen(movies: _movies))))),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 214,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: _movies.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final movie = _movies[index];
                    return CinematicCard(
                      movie: movie,
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: movie))),
                    );
                  },
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 26, 20, 12),
              sliver: SliverToBoxAdapter(child: _sectionTitle('Genre', () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CategoriesScreen(movies: _movies))))),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              sliver: SliverToBoxAdapter(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _movies.map((movie) => ActionChip(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => FilmsScreen(movies: _movies, initialQuery: movie.genre))),
                    label: Text(movie.genre),
                    backgroundColor: AppTheme.surfaceSoft,
                  )).toSet().toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectNav,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.local_movies_outlined), selectedIcon: Icon(Icons.local_movies), label: 'Film'),
          NavigationDestination(icon: Icon(Icons.category_outlined), selectedIcon: Icon(Icons.category), label: 'Kategori'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _topBar() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.asset('assets/images/javix_logo.png', width: 52, height: 52, fit: BoxFit.cover),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('JAVIX', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 2.5)),
            Text('CINEMA', style: TextStyle(color: AppTheme.primaryBright, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 3)),
          ],
        ),
        const Spacer(),
        IconButton(
          tooltip: 'Notifikasi',
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsScreen())),
          icon: const Icon(Icons.notifications_none_rounded),
        ),
      ],
    );
  }

  Widget _searchBar() {
    return TextField(
      controller: _searchController,
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => _openSearch(),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search_rounded),
        hintText: 'Cari film, aktor, atau genre...',
        suffixIcon: IconButton(onPressed: _openSearch, icon: const Icon(Icons.arrow_forward_rounded)),
      ),
    );
  }

  Widget _hero() {
    return Container(
      height: 235,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF16415F), Color(0xFF07111F), Color(0xFF050A14)]),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('JAVIX CINEMA', style: TextStyle(color: AppTheme.primaryBright, fontWeight: FontWeight.w800, letterSpacing: 2, fontSize: 12)),
          const SizedBox(height: 8),
          const Text('Your next movie night\nstarts here.', style: TextStyle(fontSize: 27, height: 1.08, fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => FilmsScreen(movies: _movies))),
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Explore films'),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, VoidCallback onSeeAll) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
        const Spacer(),
        TextButton(onPressed: onSeeAll, child: const Text('Lihat semua')),
      ],
    );
  }
}
