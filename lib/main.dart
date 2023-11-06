import 'package:flutter/material.dart';
import 'package:image_parts_click/map_svg_data.dart';
import 'package:image_parts_click/parser/parser.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Clickable SVG map of The Netherlands',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Province? _pressedProvince;
  ScrollController controller = ScrollController();
  final svgPath = "images/ng.svg";
  List<Path> paths = [];
  Path? _selectedPath;
  double heightSvg = 0;
  double widthSvg = 0;
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
        appBar: AppBar(title: const Text('Provinces of The Netherlands')),
        body: SafeArea(
            child: Transform.scale(
                scale: ((height / MapSvgData.height)) * scaleFactor,
                child: Transform.translate(
                    offset: offset, child: Stack(children: _buildMap())))));
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
        child: Stack(children: <Widget>[
          CustomPaint(painter: PathPainter(province)),
          Material(
              color: Colors.transparent,
              child: InkWell(
                  onTap: () => _provincePressed(province),
                  child: Container(
                      color: _pressedProvince == province
                          ? const Color(0xFF7C7C7C)
                          : Colors.transparent)))
        ]));
  }

  void _provincePressed(Province province) {
    setState(() {
      _pressedProvince = province;
    });
  }

  void parseSvgToPath() {
    SvgParser parser = SvgParser();
    parser.loadFromFile(svgPath).then((value) {
      setState(() {
        paths = parser.getPaths();
        heightSvg = parser.svgHeight!;
        widthSvg = parser.svgWidth!;
      });
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
          ..strokeWidth = 2.0);
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
