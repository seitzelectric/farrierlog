import 'dart:io';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../utils/utils.dart';

class ClientAvatar extends StatelessWidget {
  final Client client;
  final double radius;

  const ClientAvatar({super.key, required this.client, this.radius = 24});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: Text(
        client.initials,
        style: TextStyle(
          fontSize: radius * 0.7,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}

class HorseAvatar extends StatelessWidget {
  final Horse horse;
  final double radius;

  const HorseAvatar({super.key, required this.horse, this.radius = 24});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      child: Icon(
        Icons.pets,
        size: radius * 1.2,
        color: Theme.of(context).colorScheme.onTertiaryContainer,
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onAdd;
  final String? addLabel;

  const SectionHeader({
    super.key,
    required this.title,
    this.onAdd,
    this.addLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Spacer(),
          if (onAdd != null)
            TextButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add, size: 18),
              label: Text(addLabel ?? 'Add'),
            ),
        ],
      ),
    );
  }
}

class PhotoGrid extends StatelessWidget {
  final List<VisitPhoto> photos;
  final Function(VisitPhoto)? onTap;
  final Function(VisitPhoto)? onLongPress;
  final bool showCaptionBelow;

  const PhotoGrid({
    super.key,
    required this.photos,
    this.onTap,
    this.onLongPress,
    this.showCaptionBelow = false,
  });

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) return const SizedBox.shrink();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: showCaptionBelow ? 2 : 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: showCaptionBelow ? 16 : 8,
        childAspectRatio: showCaptionBelow ? 0.85 : 1.0,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        final file = File(photo.path);

        final imageWidget = ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (file.existsSync())
                Image.file(
                  file,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildErrorPlaceholder(context),
                )
              else
                _buildErrorPlaceholder(context),
              if (photo.includeOnInvoice)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.receipt_long,
                      size: 14,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              if (!showCaptionBelow && photo.caption.isNotEmpty)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 2),
                    color: Colors.black54,
                    child: Text(
                      photo.caption,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
            ],
          ),
        );

        if (showCaptionBelow) {
          return GestureDetector(
            onTap: () => onTap?.call(photo),
            onLongPress: () => onLongPress?.call(photo),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: imageWidget),
                if (photo.caption.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    photo.caption,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          );
        }

        return GestureDetector(
          onTap: () => onTap?.call(photo),
          onLongPress: () => onLongPress?.call(photo),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageWidget,
          ),
        );
      },
    );
  }

  Widget _buildErrorPlaceholder(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Icon(
        Icons.broken_image,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }
}

class ServiceLineCard extends StatelessWidget {
  final ServiceLine line;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ServiceLineCard({
    super.key,
    required this.line,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          child: Icon(
              line.isGroup ? Icons.groups : Icons.handyman,
              color: Theme.of(context).colorScheme.onSecondaryContainer),
        ),
        title: Text(line.isGroup
            ? (line.groupLabel?.isNotEmpty == true
                ? line.groupLabel!
                : 'Group')
            : line.description),
        subtitle: line.isGroup
            ? Text('${line.description} · × ${line.quantity} animals')
            : Text(line.horseName),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              line.isGroup
                  ? '${AppUtils.formatCurrency(line.price)} × ${line.quantity} = ${AppUtils.formatCurrency(line.lineTotal)}'
                  : AppUtils.formatCurrency(line.lineTotal),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (onEdit != null || onDelete != null)
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') onEdit?.call();
                  if (value == 'delete') onDelete?.call();
                },
                itemBuilder: (context) => [
                  if (onEdit != null)
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  if (onDelete != null)
                    const PopupMenuItem(
                      value: 'delete',
                      child:
                          Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class VisitStatusChip extends StatelessWidget {
  final Visit visit;

  const VisitStatusChip({super.key, required this.visit});

  @override
  Widget build(BuildContext context) {
    if (visit.isAutoGenerated) {
      return Chip(
        avatar: Icon(
          Icons.event_available,
          size: 18,
          color: Theme.of(context).colorScheme.primary,
        ),
        label: const Text('Projected'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      );
    } else if (visit.paid) {
      return Chip(
        avatar: const Icon(Icons.check_circle, size: 18, color: Colors.green),
        label: const Text('Paid'),
        backgroundColor: Colors.green.shade50,
      );
    } else if (visit.isPast) {
      return Chip(
        avatar: const Icon(Icons.warning, size: 18, color: Colors.red),
        label: const Text('Overdue'),
        backgroundColor: Colors.red.shade50,
      );
    } else if (visit.isToday) {
      return Chip(
        avatar: const Icon(Icons.today, size: 18, color: Colors.blue),
        label: const Text('Today'),
        backgroundColor: Colors.blue.shade50,
      );
    } else {
      return Chip(
        avatar: const Icon(Icons.schedule, size: 18, color: Colors.orange),
        label: const Text('Upcoming'),
        backgroundColor: Colors.orange.shade50,
      );
    }
  }
}

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final Color? confirmColor;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Delete',
    this.confirmColor,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            confirmLabel,
            style: TextStyle(color: confirmColor ?? Colors.red),
          ),
        ),
      ],
    );
  }

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Delete',
    Color? confirmColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => ConfirmationDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        confirmColor: confirmColor,
      ),
    );
  }
}
