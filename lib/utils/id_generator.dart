import 'dart:math';

class IDGenerator {
  /// Génère un identifiant unique basé sur un préfixe et un horodatage
  static String generateID(String prefix) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomSuffix = Random().nextInt(10000); // Génère un nombre entre 0 et 9999
    return '$prefix-$timestamp-$randomSuffix';
  }
}
