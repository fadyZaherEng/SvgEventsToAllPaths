// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:image_parts_click/map_svg_data.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clickable SVG ',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Path? _pressedProvince;

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
      appBar: AppBar(
        title: const Text(
          'Svg Paths Actions',
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: _buildMap(),
        ),
      ),
    );
  }

  List<Widget> _buildMap() {
    List<Widget> provinces = [];
    for (int i = 0; i < MapSvgData.paths.length; i++) {
      provinces.add(_buildProvince(MapSvgData.getPath(i)));
    }
    return provinces;
  }

  Widget _buildProvince(Path province) {
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

  void _provincePressed(Path province) {
    setState(() {
      print(province);
      _pressedProvince = province;
    });
  }
}

class PathPainter extends CustomPainter {
  final Path _province;

  PathPainter(this._province);

  @override
  void paint(Canvas canvas, Size size) {
    //Path path = getPathByProvince(_province);
    canvas.drawPath(
      _province,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.black
        ..strokeWidth = 2.0
        ..isAntiAlias,
    );
  }

  @override
  bool shouldRepaint(PathPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(PathPainter oldDelegate) => false;
}

class PathClipper extends CustomClipper<Path> {
  final Path _province;

  PathClipper(this._province);

  @override
  Path getClip(Size size) {
    return _province;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
