import 'match.dart';

class Tournoi {
  final String id;
  final String nom;
  final List<String> joueurs;
  final List<List<String>> groupes;
  final List<Match> matchs; // Matchs de la phase de groupe
  final int bestOfGroupes;
  final int bestOfEliminatoires;
  final int bestOfFinale;

  List<String> joueursQualifies; // Liste des joueurs qualifiés pour la phase éliminatoire
  List<Match> matchsEliminatoires; // Matchs de la phase éliminatoire

  Tournoi({
    required this.id,
    required this.nom,
    required this.joueurs,
    required this.groupes,
    required this.matchs,
    required this.bestOfGroupes,
    required this.bestOfEliminatoires,
    required this.bestOfFinale,
    this.joueursQualifies = const [],
    this.matchsEliminatoires = const [],
  });

  factory Tournoi.fromJson(Map<String, dynamic> json) {
    return Tournoi(
      id: json['id'],
      nom: json['nom'],
      joueurs: List<String>.from(json['joueurs']),
      groupes: (json['groupes'] as List).map((g) => List<String>.from(g)).toList(),
      matchs: (json['matchs'] as List).map((m) => Match.fromJson(m)).toList(),
      bestOfGroupes: json['bestOfGroupes'] ?? 1,
      bestOfEliminatoires: json['bestOfEliminatoires'] ?? 1,
      bestOfFinale: json['bestOfFinale'] ?? 1,
      joueursQualifies: List<String>.from(json['joueursQualifies'] ?? []),
      matchsEliminatoires: (json['matchsEliminatoires'] as List?)
          ?.map((m) => Match.fromJson(m))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'joueurs': joueurs,
      'groupes': groupes.map((g) => g.toList()).toList(),
      'matchs': matchs.map((m) => m.toJson()).toList(),
      'bestOfGroupes': bestOfGroupes,
      'bestOfEliminatoires': bestOfEliminatoires,
      'bestOfFinale': bestOfFinale,
      'joueursQualifies': joueursQualifies,
      'matchsEliminatoires': matchsEliminatoires.map((m) => m.toJson()).toList(),
    };
  }
}
