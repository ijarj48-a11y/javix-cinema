import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/cinematic_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
              sliver: SliverToBoxAdapter(child: _searchBar()),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
              sliver: SliverToBoxAdapter(child: _hero()),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 14),
              sliver: SliverToBoxAdapter(child: _sectionTitle('Trending now')),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 215,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  separatorBuilder: (_, _) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    return CinematicCard(
                      title: 'Movie ${index + 1}',
                      subtitle: 'Coming soon',
                    );
                  },
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 90),
              sliver: SliverToBoxAdapter(child: _sectionTitle('Browse by mood')),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppTheme.surface,
        selectedIndex: 0,
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

  Widget _topBar() {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [AppTheme.primaryBright, AppTheme.primary],
            ),
          ),
          child: const Icon(Icons.play_arrow_rounded, color: Colors.black),
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
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded),
        ),
      ],
    );
  }

  Widget _searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: const TextField(
        decoration: InputDecoration(
          icon: Icon(Icons.search_rounded),
          hintText: 'Cari film, aktor, atau genre...',
          border: InputBorder.none,
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
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF16415F), Color(0xFF07111F), Color(0xFF050A14)],
        ),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.18)),
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
            onPressed: () {},
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Explore films'),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
        ),
        const Spacer(),
        TextButton(onPressed: () {}, child: const Text('See all')),
      ],
    );
  }
}
