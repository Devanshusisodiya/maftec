class APIRoutes {
  static String ip = '10.0.2.2';
  static String port = '5000';
  static String base = 'http://$ip:$port';
  static String uploadRoute = '$base/image';
  static String classificationRoute = '$base/image/classify';
}
