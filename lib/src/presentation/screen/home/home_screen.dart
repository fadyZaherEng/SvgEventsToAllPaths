// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_parts_click/src/domain/get_svg_paths.dart';
import 'package:image_parts_click/src/presentation/bloc/svg/svg_bloc.dart';
import 'package:image_parts_click/src/presentation/screen/home/widgets/build_svg_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SvgBloc get _bloc => BlocProvider.of<SvgBloc>(context);
  Path pathSelected = Path();
  MapSvgPaths mapSvgData = MapSvgPaths();

  @override
  void initState() {
    _bloc.add(SvgGetPathEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SvgBloc, SvgState>(
      listener: (context, state) {
        if (state is SvgPressedPathState) {
          pathSelected = state.path;
        } else if (state is SvgGetPathState) {
          mapSvgData = state.mapSvgData;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: const Text(
              'Svg Paths Actions',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: BuildSvgWidget(
              onPressedPath: (path) {
                _bloc.add(SvgPressedPathEvent(path: path));
              },
              pathSelected: pathSelected,
              mapSvgData: mapSvgData,
            ),
          ),
        );
      },
    );
  }
}
