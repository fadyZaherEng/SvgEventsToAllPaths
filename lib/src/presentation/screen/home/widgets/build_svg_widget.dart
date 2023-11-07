// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:image_parts_click/src/domain/get_svg_paths.dart';
import 'package:image_parts_click/src/presentation/screen/home/widgets/build_path_widget.dart';

class BuildSvgWidget extends StatefulWidget {
  void Function(Path path) onPressedPath;
  final Path pathSelected;
  final MapSvgPaths mapSvgData;

  BuildSvgWidget({
    super.key,
    required this.onPressedPath,
    required this.pathSelected,
    required this.mapSvgData,
  });

  @override
  State<BuildSvgWidget> createState() => _BuildSvgWidgetState();
}

class _BuildSvgWidgetState extends State<BuildSvgWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (int i = 0; i < widget.mapSvgData.paths.length; i++)
          BuildPathWidget(
            path: widget.mapSvgData.getPath(i),
            selectedPath: widget.pathSelected,
            onPressedPath: widget.onPressedPath,
          )
      ],
    );
  }
}
