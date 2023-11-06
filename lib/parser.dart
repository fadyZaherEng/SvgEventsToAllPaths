// ignore_for_file: unnecessary_null_comparison

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_parsing/path_parsing.dart';
import 'package:xml/xml.dart' as xml;
//SVG parsing

/// Parses a minimal subset of a SVG file and extracts all paths segments.
class SvgParser {
  /// Each [PathSegment] represents a continuous Path element of the parent Path
  final List<PathSegment> _pathSegments = <PathSegment>[];
  List<Path> _paths = <Path>[];

  //Extract segments of each path and create [PathSegment] representation
  void addPathSegments(
      Path path, int index, double? strokeWidth, Color? color) {
    int firstPathSegmentIndex = _pathSegments.length;
    int relativeIndex = 0;
    path.computeMetrics().forEach((pp) {
      PathSegment segment = PathSegment()
        ..path = pp.extractPath(0, pp.length)
        ..length = pp.length
        ..firstSegmentOfPathIndex = firstPathSegmentIndex
        ..pathIndex = index
        ..relativeIndex = relativeIndex;

      if (color != null) segment.color = color;

      if (strokeWidth != null) segment.strokeWidth = strokeWidth;

      _pathSegments.add(segment);
      relativeIndex++;
    });
  }

  double width = 0;
  double height = 0;
  String viewbox = "";
  double? get svgWidth {
    return width;
  }

  double? get svgHeight {
    return height;
  }

  void loadFromString(String svgString) {
    _pathSegments.clear();
    int index = 0;
    var doc = xml.XmlDocument.parse(svgString);

    doc.findElements("svg").map((e) => e.attributes).forEach((node) {
      var someH = node.firstWhere((attr) => attr.name.local == "height",
          orElse: () => xml.XmlAttribute(
                xml.XmlName.fromString("qualified"),
                "",
              ));
      height = double.tryParse(someH.value)!;
      var someW = node.firstWhere((attr) => attr.name.local == "width",
          orElse: () => xml.XmlAttribute(
                xml.XmlName.fromString("qualified"),
                "",
              ));
      width = double.tryParse(someW.value)!;
      var someViewBox = node.firstWhere((attr) => attr.name.local == "viewbox",
          orElse: () => xml.XmlAttribute(
                xml.XmlName.fromString("qualified"),
                "",
              ));
      viewbox = someViewBox.value;
    });

    doc
        .findAllElements("path")
        .map((node) => node.attributes)
        .forEach((attributes) {
      // print('attributes[0].name.local: ${attributes[0].name.local}');
      var dPath = attributes.firstWhere((attr) => attr.name.local == "d",
          orElse: () => xml.XmlAttribute(
                xml.XmlName.fromString("qualified"),
                "",
              ));
      Path path = Path();
      writeSvgPathDataToPath(dPath.value, PathModifier(path));

      Color? color;
      double? strokeWidth;

      //Attributes - [1] css-styling
      var style = attributes.firstWhere((attr) => attr.name.local == "style",
          orElse: () => xml.XmlAttribute(
                xml.XmlName.fromString("qualified"),
                "",
              ));
      if (style != null) {
        //Parse color of stroke
        RegExp exp = RegExp(r"stroke:([^;]+);");
        RegExpMatch? match = exp.firstMatch(style.value);
        exp = RegExp(r"stroke-width:([0-9.]+)");
        match = exp.firstMatch(style.value);
        if (match != null) {
          String? cStr = match.group(1);
          strokeWidth = double.tryParse(cStr ?? "");
        }
      }
      var strokeWidthElement =
          attributes.firstWhere((attr) => attr.name.local == "stroke-width",
              orElse: () => xml.XmlAttribute(
                    xml.XmlName.fromString("qualified"),
                    "",
                  ));
      if (strokeWidthElement != null) {
        strokeWidth = double.tryParse(strokeWidthElement.value);
      }
      _paths.add(path);
      addPathSegments(path, index, strokeWidth, color);
      index++;
    });
  }

  void loadFromPaths(List<Path> paths) {
    _pathSegments.clear();
    _paths = paths;

    int index = 0;
    for (var p in paths) {
      addPathSegments(p, index, null, null);
      index++;
    }
  }

  /// Parses Svg from provided asset path
  Future<void> loadFromFile(String file) async {
    _pathSegments.clear();
    String svgString = await rootBundle.loadString(file);
    loadFromString(svgString);
  }

  /// Returns extracted [PathSegment] elements of parsed Svg
  List<PathSegment> getPathSegments() {
    return _pathSegments;
  }

  /// Returns extracted [Path] elements of parsed Svg
  List<Path> getPaths() {
    return _paths;
  }
}

/// Represents a segment of path, as returned by path.computeMetrics() and the associated painting parameters for each Path
class PathSegment {
  PathSegment()
      : strokeWidth = 0.0,
        color = Colors.black,
        firstSegmentOfPathIndex = 0,
        relativeIndex = 0,
        pathIndex = 0;

  /// A continuous path/segment
  Path? path;
  double? strokeWidth;
  Color? color;

  /// Length of the segment path
  double? length;

  /// Denotes the index of the first segment of the containing path when PathOrder.original
  int? firstSegmentOfPathIndex;

  /// Corresponding containing path index
  int? pathIndex;

  /// Denotes relative index to  firstSegmentOfPathIndex
  int? relativeIndex;
}

/// A [PathProxy] that saves Path command in path
class PathModifier extends PathProxy {
  PathModifier(this.path);

  Path path;

  @override
  void close() {
    path.close();
  }

  @override
  void cubicTo(
      double x1, double y1, double x2, double y2, double x3, double y3) {
    path.cubicTo(x1, y1, x2, y2, x3, y3);
  }

  @override
  void lineTo(double x, double y) {
    path.lineTo(x, y);
  }

  @override
  void moveTo(double x, double y) {
    path.moveTo(x, y);
  }
}
