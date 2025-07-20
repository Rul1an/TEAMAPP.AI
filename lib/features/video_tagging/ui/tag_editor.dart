import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/tag_type.dart';
import '../models/video_tag.dart';
import '../providers/tag_providers.dart';
import 'package:uuid/uuid.dart';
import '../../../analytics/tagging_analytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class TagEditor extends ConsumerStatefulWidget {
  const TagEditor(
      {required this.videoId, required this.initialTimestamp, super.key,});

  final String videoId;
  final int initialTimestamp;

  @override
  ConsumerState<TagEditor> createState() => _TagEditorState();
}

class _TagEditorState extends ConsumerState<TagEditor> {
  late int _timestamp;
  final _labelCtrl = TextEditingController();
  TagType _type = TagType.tactical;

  @override
  void initState() {
    super.initState();
    _timestamp = widget.initialTimestamp;
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final repo = ref.read(tagRepositoryProvider);
    final analytics = TaggingAnalytics(FirebaseAnalytics.instance);
    final tag = VideoTag(
      id: const Uuid().v4(),
      videoId: widget.videoId,
      timestamp: _timestamp,
      label: _labelCtrl.text.trim(),
      type: _type,
    );
    await repo.create(tag);
    await analytics.logTagAdded(tag);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Tag'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _labelCtrl,
            decoration: const InputDecoration(labelText: 'Label'),
          ),
          DropdownButton<TagType>(
            value: _type,
            onChanged: (t) => setState(() => _type = t!),
            items: TagType.values
                .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
                .toList(),
          ),
          Slider(
            min: 0,
            max: (_timestamp + 600).toDouble(),
            value: _timestamp.toDouble(),
            onChanged: (v) => setState(() => _timestamp = v.round()),
            label: '$_timestamp s',
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),),
        ElevatedButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
