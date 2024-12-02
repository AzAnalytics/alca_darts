class Match {
  final String id;
  final String joueur1;
  final String joueur2;
  final int piste;
  int scoreJoueur1; // Score total du joueur 1
  int scoreJoueur2; // Score total du joueur 2
  int manchesJoueur1; // Nombre de manches gagnées par le joueur 1
  int manchesJoueur2; // Nombre de manches gagnées par le joueur 2

  Match({
    required this.id,
    required this.joueur1,
    required this.joueur2,
    required this.piste,
    this.scoreJoueur1 = 0,
    this.scoreJoueur2 = 0,
    this.manchesJoueur1 = 0,
    this.manchesJoueur2 = 0,
  });


/// Convertit l'objet Match en un format JSON (Map)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'joueur1': joueur1,
      'joueur2': joueur2,
      'piste': piste,
      'scoreJoueur1': scoreJoueur1,
      'scoreJoueur2': scoreJoueur2,
      'manchesJoueur1' : manchesJoueur1,
      'manchesJoueur2' : manchesJoueur2
    };
  }

  /// Crée un objet Match à partir d'un format JSON (Map)
  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'],
      joueur1: json['joueur1'],
      joueur2: json['joueur2'],
      piste: json['piste'],
      scoreJoueur1: json['scoreJoueur1'],
      scoreJoueur2: json['scoreJoueur2'],
      manchesJoueur1: json['manchesJoueur1'],
      manchesJoueur2: json['manchesJoueur2']
    );
  }
}
