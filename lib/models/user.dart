class User {
  final String id;              // Identifiant unique de l'utilisateur
  final String nom;             // Nom de l'utilisateur
  final String prenom;          // Prénom de l'utilisateur
  final String pseudo;          // Pseudo unique de l'utilisateur
  final String regionDeLigue;   // Région de ligue de l'utilisateur
  final bool sansClub;          // Indique si l'utilisateur est sans club

  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.pseudo,
    required this.regionDeLigue,
    this.sansClub = false, // Par défaut, l'utilisateur n'est pas "sans club"
  });

  /// Convertit l'objet User en un format JSON (Map)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'pseudo': pseudo,
      'regionDeLigue': regionDeLigue,
      'sansClub': sansClub,
    };
  }

  /// Crée un objet User à partir d'un format JSON (Map)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      pseudo: json['pseudo'],
      regionDeLigue: json['regionDeLigue'],
      sansClub: json['sansClub'],
    );
  }
}
