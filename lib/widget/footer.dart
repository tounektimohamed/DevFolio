import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.fromLTRB(0, height * 0.05, 0, 0),
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Developed in 💙 with ",
              ),
              InkWell(
                onTap: () => _openURL("https://github.com/tounektimohamed/DevFolio"),
                child: const Text(
                  "Flutter",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20), // Espacement entre le texte et la carte
          const Text(
            "My Location",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: height * 0.3, // Adjusted height for better map view
            width: width * 0.8, // Adjusted width for better map view
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(32.8822047, 10.4984132), // Updated coordinates
                zoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(32.8822047, 10.4984132), // Updated coordinates
                      builder: (ctx) => Container(
                        child: Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
