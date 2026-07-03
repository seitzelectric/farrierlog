import 'dart:io';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../utils/utils.dart';

class PhotoComparisonScreen extends StatefulWidget {
  final List<VisitPhotoWithVisit> photos;
  final int initialLeftIndex;
  final int initialRightIndex;

  const PhotoComparisonScreen({
    super.key,
    required this.photos,
    this.initialLeftIndex = 0,
    int? initialRightIndex,
  }) : initialRightIndex =
            initialRightIndex ?? (photos.length > 1 ? photos.length - 1 : 0);

  @override
  State<PhotoComparisonScreen> createState() => _PhotoComparisonScreenState();
}

class _PhotoComparisonScreenState extends State<PhotoComparisonScreen> {
  late int _leftIndex;
  late int _rightIndex;

  @override
  void initState() {
    super.initState();
    _leftIndex = widget.initialLeftIndex;
    _rightIndex = widget.initialRightIndex;
  }

  VisitPhotoWithVisit get _left => widget.photos[_leftIndex];
  VisitPhotoWithVisit get _right => widget.photos[_rightIndex];

  String _elapsed() {
    final days =
        _right.visit.dateTime.difference(_left.visit.dateTime).inDays.abs();
    if (days < 7) return '$days days';
    final weeks = (days / 7).round();
    return '$weeks week${weeks == 1 ? '' : 's'}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Comparison'),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            tooltip: 'Swap photos',
            onPressed: () => setState(() {
              final tmp = _leftIndex;
              _leftIndex = _rightIndex;
              _rightIndex = tmp;
            }),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_leftIndex != _rightIndex)
            Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.primaryContainer,
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                '${_elapsed()} between these visits',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          Expanded(
            child: Row(
              children: [
                _PhotoPane(
                  entry: _left,
                  label: 'BEFORE',
                  photoCount: widget.photos.length,
                  currentIndex: _leftIndex,
                  onChanged: (i) => setState(() => _leftIndex = i),
                ),
                const VerticalDivider(width: 1),
                _PhotoPane(
                  entry: _right,
                  label: 'AFTER',
                  photoCount: widget.photos.length,
                  currentIndex: _rightIndex,
                  onChanged: (i) => setState(() => _rightIndex = i),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    AppUtils.formatDate(_left.visit.dateTime),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    AppUtils.formatDate(_right.visit.dateTime),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PhotoPane extends StatelessWidget {
  final VisitPhotoWithVisit entry;
  final String label;
  final int photoCount;
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const _PhotoPane({
    required this.entry,
    required this.label,
    required this.photoCount,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final file = File(entry.photo.path);
    return Expanded(
      child: Stack(
        children: [
          Positioned.fill(
            child: file.existsSync()
                ? InteractiveViewer(
                    child: Image.file(file, fit: BoxFit.cover),
                  )
                : const Center(child: Icon(Icons.broken_image, size: 48)),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (entry.photo.caption.isNotEmpty)
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  entry.photo.caption,
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          if (photoCount > 2) ...[
            if (currentIndex > 0)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () => onChanged(currentIndex - 1),
                  child: Container(
                    width: 32,
                    color: Colors.black12,
                    child:
                        const Icon(Icons.chevron_left, color: Colors.white),
                  ),
                ),
              ),
            if (currentIndex < photoCount - 1)
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () => onChanged(currentIndex + 1),
                  child: Container(
                    width: 32,
                    color: Colors.black12,
                    child:
                        const Icon(Icons.chevron_right, color: Colors.white),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
