bool checkServiceArea(double latitude, double longitude) {
  // Check if the given latitude and longitude fall within the service area of Abbottabad

  double minLatitude = 34.1337; // Minimum latitude of the service area
  double maxLatitude = 34.2255; // Maximum latitude of the service area
  double minLongitude = 73.2075; // Minimum longitude of the service area
  double maxLongitude = 73.3054; // Maximum longitude of the service area

  if (latitude >= minLatitude &&
      latitude <= maxLatitude &&
      longitude >= minLongitude &&
      longitude <= maxLongitude) {
    return true; // User is within the service area
  } else {
    return false; // User is outside the service area
  }
}
