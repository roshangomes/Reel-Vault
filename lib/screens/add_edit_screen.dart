import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/categories.dart';
import '../models/reel.dart';
import '../providers/reel_provider.dart';

class AddEditScreen extends StatefulWidget {
  final Reel? reel;
  final String? initialUrl; // from share intent

  const AddEditScreen({super.key, this.reel, this.initialUrl});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _urlCtrl;
  late final TextEditingController _notesCtrl;
  late String _category;
  bool _saving = false;

  bool get _isEditing => widget.reel != null;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.reel?.title ?? '');
    _urlCtrl = TextEditingController(
        text: widget.reel?.url ?? widget.initialUrl ?? '');
    _notesCtrl = TextEditingController(text: widget.reel?.notes ?? '');
    _category = widget.reel?.category ?? kCategories.first.id;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _urlCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final provider = context.read<ReelProvider>();

    if (_isEditing) {
      await provider.updateReel(
        widget.reel!.copyWith(
          title: _titleCtrl.text,
          url: _urlCtrl.text,
          category: _category,
          notes: _notesCtrl.text,
        ),
      );
    } else {
      await provider.addReel(
        title: _titleCtrl.text,
        url: _urlCtrl.text,
        category: _category,
        notes: _notesCtrl.text,
      );
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit reel' : 'Save reel'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // URL field
            TextFormField(
              controller: _urlCtrl,
              decoration: const InputDecoration(
                labelText: 'Reel URL',
                hintText: 'Paste the link here',
                prefixIcon: Icon(Icons.link_rounded),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
              autocorrect: false,
            ),
            const SizedBox(height: 16),

            // Title field
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Title *',
                hintText: 'What is this reel about?',
                prefixIcon: Icon(Icons.title_rounded),
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Add a title' : null,
            ),
            const SizedBox(height: 24),

            // Category picker
            Text(
              'Category',
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.8,
              children: kCategories.map((cat) {
                final sel = _category == cat.id;
                return GestureDetector(
                  onTap: () => setState(() => _category = cat.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      color: sel ? cat.color : cat.lightBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: sel
                            ? cat.color
                            : cat.color.withOpacity(0.35),
                        width: sel ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Icon(
                          cat.icon,
                          color: sel ? Colors.white : cat.color,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            cat.label,
                            style: TextStyle(
                              color: sel ? Colors.white : cat.color,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Notes field
            TextFormField(
              controller: _notesCtrl,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                hintText: 'Anything you want to remember...',
                prefixIcon: Icon(Icons.notes_rounded),
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        ),
      ),
    );
  }
}