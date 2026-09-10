import 'package:flutter/material.dart';
import "package:hafiz/core/localization/app_localizations.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hafiz/core/localization/localization.dart';
import 'package:hafiz/core/widgets/loading.dart';
import 'package:hafiz/features/quran/domain/entities/surah.dart';
import 'package:hafiz/features/quran/domain/entities/juz.dart';
import 'package:hafiz/features/quran/domain/repositories/curriculum_provider.dart';

class QuranBrowseView extends ConsumerStatefulWidget {
  const QuranBrowseView({super.key});

  @override
  ConsumerState<QuranBrowseView> createState() => _QuranBrowseViewState();
}

class _QuranBrowseViewState extends ConsumerState<QuranBrowseView> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l.title),
        bottom: TabBar(
          onTap: (index) => setState(() => _currentTab = index),
          tabs: [
            Tab(text: context.l.tabSurahs),
            Tab(text: context.l.tabJuzs),
          ],
        ),
      ),
      body: _currentTab == 0 ? _buildSurahList() : _buildJuzList(),
    );
  }

  Widget _buildSurahList() {
    final surahsAsync = ref.watch(surahsProvider);

    return surahsAsync.when(
      loading: () => const AppLoading(),
      error: (e, _) => Center(child: Text(e.toString())),
      data: (surahs) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: surahs.length,
        itemBuilder: (context, index) {
          final surah = surahs[index];
          return _SurahCard(surah: surah);
        },
      ),
    );
  }

  Widget _buildJuzList() {
    final juzsAsync = ref.watch(juzsProvider);

    return juzsAsync.when(
      loading: () => const AppLoading(),
      error: (e, _) => Center(child: Text(e.toString())),
      data: (juzs) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: juzs.length,
        itemBuilder: (context, index) {
          final juz = juzs[index];
          return _JuzCard(juz: juz);
        },
      ),
    );
  }
}

class _SurahCard extends StatelessWidget {
  const _SurahCard({required this.surah});

  final Surah surah;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${surah.number}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          surah.nameArabic,
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.end,
        ),
        subtitle: Text(
          '${surah.nameEnglish} - ${surah.nameTransliteration}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${surah.totalAyahs} ${context.l.ayahs}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              surah.revelationType.displayNameAr,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JuzCard extends StatelessWidget {
  const _JuzCard({required this.juz});

  final Juz juz;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${juz.number}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          juz.nameArabic,
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.end,
        ),
        subtitle: Text(juz.nameEnglish),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${juz.startPage}-${juz.endPage} ${context.l.pages}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              '${juz.surahNumbers.length} ${context.l.surahs}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
