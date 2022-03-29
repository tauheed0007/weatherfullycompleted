import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/services/location.dart';
import 'package:weather/services/networking.dart';
import 'location_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';



const String apiKey = 'cc422f1da9d1a8aaadf317ac2ad5f7db';

class LoadingScreen extends StatefulWidget {
  
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  @override
  void initState () {
    determinePosition();
    getLocationData();
    super.initState();
  }



  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }


  void getLocationData() async {

    Location location = new Location();
    await location.getCurrentLocation();

    NetworkHelper networkHelper = NetworkHelper('https://api.openweathermap.org/data/'
        '2.5/weather?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric');

    var weatherData = await networkHelper.getData();


    Navigator.push(context, MaterialPageRoute(builder: (context){
      return LocationScreen(locationweather: weatherData,);
    }));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: SpinKitFoldingCube (
          color: Colors.white,
          size: 100.0,
        ),
      ),
    );
  }
}

