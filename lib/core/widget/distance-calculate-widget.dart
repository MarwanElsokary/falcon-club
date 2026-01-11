import 'dart:math';

/// Calculates the distance between two geographical points using the Haversine formula
/// Returns the distance in kilometers
double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double earthRadius = 6371; // Earth's radius in kilometers

  // Convert degrees to radians
  double lat1Rad = lat1 * (pi / 180);
  double lon1Rad = lon1 * (pi / 180);
  double lat2Rad = lat2 * (pi / 180);
  double lon2Rad = lon2 * (pi / 180);

  // Calculate the differences
  double dLat = lat2Rad - lat1Rad;
  double dLon = lon2Rad - lon1Rad;

  // Haversine formula
  double a =
      sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);

  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  // Distance in kilometers
  double distance = earthRadius * c;

  return distance;
}

/// Alternative function that returns distance in meters
double calculateDistanceInMeters(
  double lat1,
  double lon1,
  double lat2,
  double lon2,
) {
  return calculateDistance(lat1, lon1, lat2, lon2) * 1000;
}

/// Function that returns a formatted string with distance
String getFormattedDistance(
  double lat1,
  double lon1,
  double lat2,
  double lon2,
) {
  double distance = calculateDistance(lat1, lon1, lat2, lon2);

  if (distance < 1) {
    // Show in meters if less than 1 km
    return '${(distance * 1000).toStringAsFixed(0)} متر';
  } else {
    // Show in kilometers
    return '${distance.toStringAsFixed(2)} كم';
  }
}
