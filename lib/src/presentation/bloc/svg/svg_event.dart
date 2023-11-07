part of 'svg_bloc.dart';

@immutable
abstract class SvgEvent {}

class SvgPressedPathEvent extends SvgEvent {
  Path path;

  SvgPressedPathEvent({
    required this.path,
  });
}

class SvgGetPathEvent extends SvgEvent {}
