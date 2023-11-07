// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:image_parts_click/src/domain/get_svg_paths.dart';
import 'package:meta/meta.dart';

part 'svg_event.dart';
part 'svg_state.dart';

class SvgBloc extends Bloc<SvgEvent, SvgState> {
  SvgBloc() : super(SvgInitial()) {
    on<SvgPressedPathEvent>(_onSvgPressedPathEvent);
    on<SvgGetPathEvent>(_onSvgGetPathEvent);
  }

  FutureOr<void> _onSvgPressedPathEvent(
      SvgPressedPathEvent event, Emitter<SvgState> emit) {
    emit(SvgPressedPathState(path: event.path));
  }

  FutureOr<void> _onSvgGetPathEvent(
      SvgGetPathEvent event, Emitter<SvgState> emit) async {
    MapSvgPaths mapSvgData = MapSvgPaths();
    await mapSvgData.parseSvgToPath();
    emit(SvgGetPathState(mapSvgData: mapSvgData));
  }
}
