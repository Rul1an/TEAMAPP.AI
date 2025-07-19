import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/tag_type.dart';
import '../providers/tag_providers.dart';

class TagSearchScreen extends ConsumerStatefulWidget {
  const TagSearchScreen({super.key});

  @override
  ConsumerState<TagSearchScreen> createState() => _TagSearchScreenState();
}

class _TagSearchScreenState extends ConsumerState<TagSearchScreen> {
  TagType? _selectedType;
  final _playerCtrl = TextEditingController();

  @override
  void dispose() {
    _playerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(searchTagsProvider((
      playerId: _playerCtrl.text.isEmpty ? null : _playerCtrl.text,
      type: _selectedType,
      videoId: null,
    )));

    return Scaffold(
      appBar: AppBar(title: const Text('Search Tags')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _playerCtrl,
                    decoration: const InputDecoration(labelText: 'Player ID'),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<TagType?>(
                  value: _selectedType,
                  hint: const Text('Type'),
                  onChanged: (t) => setState(() => _selectedType = t),
                  items: [null, ...TagType.values]
                      .map((t) => DropdownMenuItem(
                            value: t,
                            child: Text(t?.name ?? 'Any'),
                          ))
                      .toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: result.when(
                data: (tags) => ListView.builder(
                  itemCount: tags.length,
                  itemBuilder: (c, i) => ListTile(
                    title: Text(tags[i].label),
                    subtitle: Text('${tags[i].type.name} – ${tags[i].timestamp}s'),
                  ),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}