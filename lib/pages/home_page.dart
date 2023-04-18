import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:codigo6_mapas/utils/map_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List data = [
    {
      "id": 1,
      "latitud": -15.4893,
      "longitud": -70.1300,
      "title": "Poder Judicial",
      "image":
          "https://w7.pngwing.com/pngs/16/681/png-transparent-executive-yuan-judicial-yuan-judiciary-premier-of-the-republic-of-china-executive-branch-creative-miscellaneous-text-bank.png",
    },
    {
      "id": 2,
      "latitud": -15.4923,
      "longitud": -70.1269,
      "title": "Bomberos",
      "image": "https://cdn-icons-png.flaticon.com/512/122/122492.png",
    },
    {
      "id": 1,
      "latitud": -15.4816,
      "longitud": -70.1332,
      "title": "Hospital ",
      "image":
          "https://p.kindpng.com/picc/s/771-7711485_seguro-de-salud-gerencia-de-riesgos-hospital-icon.png",
    },
  ];
  Set<Marker> myMarkers = {
    const Marker(
      markerId: MarkerId("m1"),
      position: LatLng(-15.4994, -70.1337),
    ),
    const Marker(
      markerId: MarkerId("m2"),
      position: LatLng(-15.4960, -70.1315),
    ),
    const Marker(
      markerId: MarkerId("m3"),
      position: LatLng(-15.4946, -70.1344),
    ),
  };
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() {
    data.forEach(
      (element) async {
        getImageMarkerBytes(element["image"], fromInternet: true).then((value) {
          Marker marker = Marker(
            markerId: MarkerId(myMarkers.length.toString()),
            position: LatLng(element["latitud"], element["longitud"]),
            icon: BitmapDescriptor.fromBytes(value),
          );
          myMarkers.add(marker);
          setState(() {});
        });
      },
    );
  }

  Future<Uint8List> getImageMarkerBytes(String path,
      {bool fromInternet = false, int width = 120}) async {
    late Uint8List bytes;
    if (fromInternet) {
      File file = await DefaultCacheManager().getSingleFile(path);
      bytes = await file.readAsBytes();
    } else {
      ByteData byteData = await rootBundle.load(path);
      bytes = byteData.buffer.asUint8List();
    }
    //tamaño de nuestra imagen
    final codec = await ui.instantiateImageCodec(bytes, targetWidth: width);
    ui.FrameInfo frame = await codec.getNextFrame();
    ByteData? myByteData =
        await frame.image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List myBytes = myByteData!.buffer.asUint8List();
    return myBytes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(-15.5080, -70.1269),
          zoom: 16,
        ),
        //activar la ubicación de nosotros GPS
        compassEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        //el tipo de mapa que queremos
        mapType: MapType.normal,
        //vamos a personalizar
        onMapCreated: (GoogleMapController controller) {
          controller.setMapStyle(json.encode(mapStyle));
        },
        //la pantalla darle zoom
        zoomControlsEnabled: true,
        //inhabilitar el zoom
        zoomGesturesEnabled: true,
        //creamos nuestros markadores
        markers: myMarkers,
        onTap: (LatLng position) async {
          Marker marker = Marker(
            markerId: MarkerId(myMarkers.length.toString()),
            position: position,
            //cambiamos el color
            // icon: BitmapDescriptor.defaultMarkerWithHue(
            // BitmapDescriptor.hueViolet),
            //personalizamos nuestro imagen
            // icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(), ""),
            icon: BitmapDescriptor.fromBytes(
              await getImageMarkerBytes(
                "https://entreplantasycafe.com/wp-content/uploads/2023/01/logo-preferente-fullcolor.png",
                fromInternet: true,
                width: 200,
              ),
            ),
            //puedo rotar mi marcador
            rotation: 0,
            //puedo mover con los nuevos agregados
            draggable: true,
            onDrag: (LatLng newPosition) {
              // print(newPosition);
            },
          );
          print(marker);
          myMarkers.add(marker);
          setState(() {});
        },
      ),
    );
  }
}
