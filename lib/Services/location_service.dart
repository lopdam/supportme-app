import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position> getPosition() async {
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    return position;
  }

  static Future<LocationPermission> getrequestPermission() async {
    LocationPermission permission = await requestPermission();
    return permission;
  }

  static Future<LocationPermission> getcheckPermission() async {
    LocationPermission permission = await checkPermission();
    return permission;
  }

  static Future<bool> is_LocationEnable() async {
    bool result = await isLocationServiceEnabled();
    return result;
  }
}
