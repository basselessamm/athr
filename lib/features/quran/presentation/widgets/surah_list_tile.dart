import 'package:flutter/material.dart';
import 'package:quran_flutter/quran.dart';
import 'package:go_router/go_router.dart';

class SurahListTile extends StatelessWidget {
  final int surahNumber;

  const SurahListTile({super.key, required this.surahNumber});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Text(
          surahNumber.toString(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        Quran.getSurahName(surahNumber),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Text('آياتها ${Quran.getTotalVersesInSurah(surahNumber)}'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        context.push('/quran/$surahNumber');
      },
    );
  }
}
