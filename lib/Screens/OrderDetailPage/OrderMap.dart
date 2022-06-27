import 'package:cached_network_image/cached_network_image.dart';
import 'package:elie_expert/Utils/Colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class OrderMap extends StatefulWidget {
  OrderMap(this.lat, this.long);
  final lat;
  final long;
  @override
  _OrderMapState createState() => _OrderMapState();
}

class _OrderMapState extends State<OrderMap> {
  late MapController controller;

  List<LatLng> markers = [];

  void _gotoDefault() {
    controller.center = LatLng(widget.lat, widget.long);

    MapsLauncher.launchCoordinates(widget.lat, widget.long).onError((error, stackTrace) {
      showTopSnackBar(
        context,
        CustomSnackBar.info(
          backgroundColor: highLcolor,
          message: "Please install Google Maps",
        ),
      );
      return false;
    });

    setState(() {});
  }

  Offset? _dragStart;
  double _scaleStart = 1.0;
  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      controller.zoom += 0.02;
      setState(() {});
    } else if (scaleDiff < 0) {
      controller.zoom -= 0.02;
      setState(() {});
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart!;
      _dragStart = now;
      controller.drag(diff.dx, diff.dy);
      setState(() {});
    }
  }

  Widget _buildMarkerWidget(Offset pos, Color color, [IconData icon = Icons.location_on]) {
    return Positioned(
      left: pos.dx - 24,
      top: pos.dy - 24,
      width: 48,
      height: 48,
      child: GestureDetector(
        child: Icon(
          icon,
          color: color,
          size: 48,
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    markers.add(LatLng(widget.lat, widget.long));
    controller = MapController(
      zoom: 9,
      location: LatLng(widget.lat, widget.long),
    );
    print(controller.zoom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapLayoutBuilder(
        controller: controller,
        builder: (context, transformer) {
          final markerPositions = markers.map(transformer.fromLatLngToXYCoords).toList();

          final markerWidgets = markerPositions.map(
            (pos) => _buildMarkerWidget(pos, highLcolorDark),
          );

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onScaleStart: _onScaleStart,
            onScaleUpdate: _onScaleUpdate,
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  final delta = event.scrollDelta;

                  controller.zoom -= delta.dy / 1000.0;
                  setState(() {});
                }
              },
              child: Stack(
                children: [
                  Map(
                    controller: controller,
                    builder: (context, x, y, z) {
                      //Legal notice: This url is only used for demo and educational purposes. You need a license key for production use.
                      //Google Maps
                      final url =
                          'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';
                      return CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  ...markerWidgets,
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: highLcolor,
        onPressed: _gotoDefault,
        tooltip: 'My Location',
        child: Icon(Icons.near_me),
      ),
    );
  }
}
