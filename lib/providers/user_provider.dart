import 'package:flutter/material.dart';
import '../models/user.dart';


class UserProvider with ChangeNotifier {
  final List<User> _users = [];

  /// Retourne une copie immuable de la liste des utilisateurs
  List<User> get users => List.unmodifiable(_users);

  /// Ajoute un nouvel utilisateur
  void ajouterUser(User user) {
    _users.add(user);
    notifyListeners();
  }

  /// Modifie un utilisateur existant
  void modifierUser(String id, User updatedUser) {
    final index = _users.indexWhere((user) => user.id == id);
    if (index != -1) {
      _users[index] = updatedUser;
      notifyListeners();
    }
  }

  /// Supprime un utilisateur par son ID
  void supprimerUser(String id) {
    _users.removeWhere((user) => user.id == id);
    notifyListeners();
  }

  /// Retourne un utilisateur par son ID, ou null s'il n'existe pas
  User? getUser(String id) {
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null; // Si aucun utilisateur n'est trouvé
    }
  }

}
