part of 'svg_bloc.dart';

@immutable
abstract class SvgState {}

class SvgInitial extends SvgState {}

class SvgPressedPathState extends SvgState {
  Path path;

  SvgPressedPathState({
    required this.path,
  });
}

class SvgGetPathState extends SvgState {
  MapSvgPaths mapSvgData;

  SvgGetPathState({
    required this.mapSvgData,
  });
}
