import 'package:codigo6_mapas/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionPage extends StatefulWidget {
  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  checkPermission(PermissionStatus status) {
    //realizamos la verificación
    switch (status) {
      case PermissionStatus.granted:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        break;
      case PermissionStatus.denied:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.restricted:
        openAppSettings();
        break;
    }
    // if (status == PermissionStatus.granted) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/img/location2.png",
            height: 220,
          ),
          Text(
              "Para user las funcionalidad del aplicativo debes activar el gps"),
          SizedBox(
            height: 12,
          ),
          OutlinedButton(
            onPressed: () async {
              // print(await Permission.location.status);
              PermissionStatus status = await Permission.location.request();
              checkPermission(status);
              // print(status);
            },
            child: Text("Activar GPS"),
          )
        ],
      ),
    ));
  }
}
