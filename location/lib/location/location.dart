import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationLogic {
  final BuildContext context;
  LocationLogic(this.context);
  double? latitude;
  double? longitude;
  bool isMockedLocation = false;
  bool isPermission = false;

  Future<Position?> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      isPermission = false;
      await CustomPopUp.showCustomDialog(
        context: context,
        iconData: Icons.location_off,
        bodyText: "Konum hizmetini açınız.",
        buttonText: "Aç",
        onTap: () {
          Geolocator.openLocationSettings();
        },
      );
      return null;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      isPermission = false;
      permission = await Geolocator.requestPermission();
    } else {
      if (permission == LocationPermission.denied) {
        isPermission = false;
        return determinePosition();
      }
    }
    if (permission == LocationPermission.deniedForever) {
      isPermission = false;
      await CustomPopUp.showCustomDialog(
        context: context,
        iconData: Icons.location_off,
        bodyText: "Konum hizmetini açınız.(deniedforever)",
        buttonText: "İzin ver",
        onTap: () {
          Geolocator.openLocationSettings();
        },
      );
      return null;
    }

    return await getCurrentLocation();
  }

  getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    isMockedLocation = position.isMocked;
    if (isMockedLocation == true) {
      await CustomPopUp.showCustomDialog(
        context: context,
        iconData: Icons.location_off,
        bodyText: "isMocked Konumunu doğru veririniz.",
        buttonText: "Tamam",
        onTap: () {
          Geolocator.openLocationSettings();
        },
      );
      return null;
    } else {
      isPermission = true;
      latitude = position.latitude;
      longitude = position.longitude;
    }
    return position;
  }
}

class CustomPopUp extends StatelessWidget {
  const CustomPopUp(
      {super.key,
      required this.bodyText,
      required this.buttonText,
      required this.onTap,
      this.iconColor,
      required this.iconData});
  final Color? iconColor;
  final String bodyText;
  final String buttonText;
  final VoidCallback onTap;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(iconData,
            size: MediaQuery.of(context).size.height * 0.06,
            color: Colors.blueGrey),
        Text(
          bodyText,
          style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Vazgeç",
                  style: TextStyle(color: Colors.grey),
                )),
            TextButton(onPressed: onTap, child: Text(buttonText)),
          ],
        )
      ],
    );
  }

  static Future<Position?> showCustomDialog(
      {required BuildContext context,
      required String bodyText,
      required String buttonText,
      required IconData iconData,
      required VoidCallback onTap,
      Color? iconColor}) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: CustomPopUp(
          iconData: iconData,
          iconColor: iconColor,
          bodyText: bodyText,
          buttonText: buttonText,
          onTap: onTap,
        ),
      ),
    );
    return null;
  }
}
