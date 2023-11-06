// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:image_parts_click/map_svg_data.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Clickable SVG map of The Netherlands',
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        debugShowCheckedModeBanner: false,
        home: const MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Province? _pressedProvince;
  @override
  void initState() {
    MapSvgData.parseSvgToPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double navBarHeight =
        Theme.of(context).platform == TargetPlatform.android ? 56.0 : 44.0;
    double safeZoneHeight = MediaQuery.of(context).padding.bottom;
    double scaleFactor = 0.5;
    double x = (width / 2.0) - (MapSvgData.width / 2.0);
    double y = (height / 2.0) -
        (MapSvgData.height / 2.0) -
        (safeZoneHeight / 2.0) -
        navBarHeight;
    Offset offset = Offset(x, y);
    return Scaffold(
      appBar: AppBar(title: const Text('Svg Paths Actions')),
      body: SafeArea(
        child: Transform.scale(
          scale: ((height / MapSvgData.height)) * scaleFactor,
          child: Transform.translate(
            offset: offset,
            child: Stack(
              children: _buildMap(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMap() {
    List<Widget> provinces = [];
    for (int i = 0; i < Province.values.length; i++) {
      provinces.add(_buildProvince(Province.values[i]));
    }
    return provinces;
  }

  Widget _buildProvince(Province province) {
    return ClipPath(
      clipper: PathClipper(province),
      child: Stack(
        children: [
          CustomPaint(
            painter: PathPainter(
              province,
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _provincePressed(province),
              child: Container(
                color: _pressedProvince == province
                    ? const Color(0xFF7C7C7C)
                    : Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _provincePressed(Province province) {
    setState(() {
      print(province);
      _pressedProvince = province;
    });
  }
}

class PathPainter extends CustomPainter {
  final Province _province;

  PathPainter(this._province);

  @override
  void paint(Canvas canvas, Size size) {
    Path path = getPathByProvince(_province);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.black
        ..strokeWidth = 2.0,
    );
  }

  @override
  bool shouldRepaint(PathPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(PathPainter oldDelegate) => false;
}

class PathClipper extends CustomClipper<Path> {
  final Province _province;

  PathClipper(this._province);

  @override
  Path getClip(Size size) {
    return getPathByProvince(_province);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
