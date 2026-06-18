import 'package:flutter/material.dart';
import '../constants/categories.dart';
import '../models/reel.dart';

class ReelTile extends StatelessWidget {
  final Reel reel;
  final VoidCallback onTap;
  final VoidCallback onToggleDone;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ReelTile({
    super.key,
    required this.reel,
    required this.onTap,
    required this.onToggleDone,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cat = categoryById(reel.category);
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: reel.url.isNotEmpty ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
          child: Row(
            children: [
              // Icon badge
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: reel.isDone
                      ? theme.colorScheme.surfaceContainerHighest
                      : cat.lightBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  reel.isDone ? Icons.check_rounded : cat.icon,
                  color: reel.isDone
                      ? theme.colorScheme.outline
                      : cat.color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),

              // Title + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reel.title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        decoration: reel.isDone
                            ? TextDecoration.lineThrough
                            : null,
                        color: reel.isDone
                            ? theme.colorScheme.outline
                            : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (reel.url.isNotEmpty || reel.notes.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        reel.url.isNotEmpty
                            ? reel.sourceDomain
                            : reel.notes,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // 3-dot menu
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (v) {
                  if (v == 'done') onToggleDone();
                  if (v == 'edit') onEdit();
                  if (v == 'delete') onDelete();
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'done',
                    child: ListTile(
                      leading: Icon(reel.isDone
                          ? Icons.undo_rounded
                          : Icons.check_circle_outline),
                      title:
                          Text(reel.isDone ? 'Mark undone' : 'Mark done'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      leading: Icon(Icons.edit_outlined),
                      title: Text('Edit'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete_outline,
                          color: theme.colorScheme.error),
                      title: Text('Delete',
                          style:
                              TextStyle(color: theme.colorScheme.error)),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
