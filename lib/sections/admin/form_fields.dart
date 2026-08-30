import 'package:flutter/material.dart';
import 'package:folio/configs/configs.dart';
import 'package:folio/utils/image_utils.dart';

InputDecoration _dec(String label, IconData icon, {String? hint}) =>
    InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, size: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[400]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppTheme.c!.primary!, width: 1.4),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      labelStyle: TextStyle(color: AppTheme.c!.textSub2),
    );

class AdminField extends StatelessWidget {
  const AdminField({
    Key? key,
    required this.label,
    required this.icon,
    required this.initial,
    required this.onChanged,
    this.maxLines = 1,
    this.hint,
    this.keyboard,
    this.isUrl = false,
  }) : super(key: key);

  final String label;
  final IconData icon;
  final String initial;
  final ValueChanged<String> onChanged;
  final int maxLines;
  final String? hint;
  final TextInputType? keyboard;
  final bool isUrl;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initial,
      maxLines: maxLines,
      keyboardType: keyboard,
      validator: (v) {
        if ((v == null || v.trim().isEmpty) && !isUrl) {
          return 'Ce champ est requis';
        }
        return null;
      },
      onChanged: onChanged,
      decoration: _dec(label, icon, hint: hint),
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}

class PhotoField extends StatelessWidget {
  const PhotoField({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.defaultValue,
  }) : super(key: key);

  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final String? defaultValue;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = value.isNotEmpty;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.c!.backgroundSub,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: hasPhoto
                ? imageOrAsset(value, height: 84, fit: BoxFit.cover)
                : Container(
                    height: 84,
                    width: 84,
                    color: Colors.grey.withOpacity(0.15),
                    child: const Icon(Icons.person, size: 40),
                  ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppText.b1b,
                ),
                const SizedBox(height: 4),
                Text(
                  hasPhoto
                      ? (value.startsWith('data:')
                          ? 'Photo personnalisée · JPG compressé'
                          : 'Image par défaut')
                      : 'Aucune photo',
                  style: AppText.l1,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () async {
                        final uri = await pickImageBase64();
                        if (uri != null) onChanged(uri);
                      },
                      icon: const Icon(Icons.file_upload_outlined, size: 16),
                      label: Text('Choisir une photo',
                          style: AppText.b1),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppTheme.c!.primary!),
                        foregroundColor: AppTheme.c!.primary,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    if (defaultValue != null && value != defaultValue)
                      TextButton.icon(
                        onPressed: () => onChanged(defaultValue!),
                        icon: const Icon(Icons.restart_alt, size: 16),
                        label: Text('Défaut', style: AppText.b1),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TagListEditor extends StatefulWidget {
  const TagListEditor({
    Key? key,
    required this.label,
    required this.tags,
    required this.onChanged,
    this.icon = Icons.tag,
  }) : super(key: key);

  final String label;
  final List<String> tags;
  final ValueChanged<List<String>> onChanged;
  final IconData icon;

  @override
  State<TagListEditor> createState() => _TagListEditorState();
}

class _TagListEditorState extends State<TagListEditor> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add() {
    final v = _controller.text.trim();
    if (v.isEmpty) return;
    if (widget.tags.contains(v)) return;
    widget.onChanged([...widget.tags, v]);
    _controller.clear();
  }

  void _remove(String t) {
    widget.onChanged(widget.tags.where((e) => e != t).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label.toUpperCase(), style: AppText.b1b),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...widget.tags.map(
              (t) => InputChip(
                label: Text(t),
                backgroundColor: AppTheme.c!.backgroundSub,
                side: BorderSide(color: AppTheme.c!.primary!.withOpacity(0.5)),
                onDeleted: () => _remove(t),
                deleteIconColor: AppTheme.c!.primary!,
              ),
            ),
            SizedBox(
              width: 190,
              child: TextFormField(
                controller: _controller,
                onFieldSubmitted: (_) => _add(),
                decoration: _dec('Ajouter', widget.icon),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class EmptyHint extends StatelessWidget {
  const EmptyHint({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppTheme.c!.backgroundSub,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: AppText.l1),
    );
  }
}