import 'package:flutter/material.dart';
import 'package:image_parts_click/src/domain/path_cliper.dart';
import 'package:image_parts_click/src/domain/path_painter.dart';

class BuildPathWidget extends StatefulWidget {
  final Path path;
  void Function(Path path) onPressedPath;
  Path selectedPath;

  BuildPathWidget({
    super.key,
    required this.path,
    required this.selectedPath,
    required this.onPressedPath,
  });

  @override
  State<BuildPathWidget> createState() => _BuildPathWidgetState();
}

class _BuildPathWidgetState extends State<BuildPathWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: PathClipper(widget.path),
      child: Stack(
        children: [
          CustomPaint(
            painter: PathPainter(
              widget.path,
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => widget.onPressedPath(
                widget.path,
              ),
              child: Container(
                color: widget.selectedPath == widget.path
                    ? Colors.grey
                    : Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
