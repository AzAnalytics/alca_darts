import 'package:flutter/material.dart';
import '../models/tournoi.dart';
import '../models/match.dart';
import '../utils/id_generator.dart';

class TournoiProvider with ChangeNotifier {
  final List<Tournoi> _tournois = [];

  /// Retourne la liste de tous les tournois
  List<Tournoi> get tournois => List.unmodifiable(_tournois);

  /// Ajoute un nouveau tournoi
  void ajouterTournoi(
      String nom,
      List<String> joueurs,
      int bestOfGroupes,
      int bestOfEliminatoires,
      int bestOfFinale,
      ) {
    final groupes = _repartirJoueursEnGroupes(joueurs);
    final matchs = _genererMatchs(groupes);

    final nouveauTournoi = Tournoi(
      id: IDGenerator.generateID('tournoi'),
      nom: nom,
      joueurs: joueurs,
      groupes: groupes,
      matchs: matchs,
      bestOfGroupes: bestOfGroupes,
      bestOfEliminatoires: bestOfEliminatoires,
      bestOfFinale: bestOfFinale,
    );

    _tournois.add(nouveauTournoi);
    notifyListeners();
  }

  /// Met à jour un tournoi existant
  void mettreAJourTournoi(
      String id,
      String nom,
      List<String> joueurs,
      int bestOfGroupes,
      int bestOfEliminatoires,
      int bestOfFinale,
      ) {
    final index = _tournois.indexWhere((t) => t.id == id);
    if (index != -1) {
      final groupes = _repartirJoueursEnGroupes(joueurs);
      final matchs = _genererMatchs(groupes);

      _tournois[index] = Tournoi(
        id: id,
        nom: nom,
        joueurs: joueurs,
        groupes: groupes,
        matchs: matchs,
        bestOfGroupes: bestOfGroupes,
        bestOfEliminatoires: bestOfEliminatoires,
        bestOfFinale: bestOfFinale,
      );
      notifyListeners();
    }
  }

  /// Supprime un tournoi par son ID
  void supprimerTournoi(String id) {
    _tournois.removeWhere((tournoi) => tournoi.id == id);
    notifyListeners();
  }

  /// Répartit les joueurs en groupes aléatoires
  List<List<String>> _repartirJoueursEnGroupes(List<String> joueurs) {
    joueurs.shuffle();
    final groupes = <List<String>>[];
    for (int i = 0; i < joueurs.length; i += 4) {
      groupes.add(joueurs.sublist(i, i + 4 > joueurs.length ? joueurs.length : i + 4));
    }
    return groupes;
  }

  /// Génère les matchs pour chaque groupe
  List<Match> _genererMatchs(List<List<String>> groupes) {
    final matchs = <Match>[];
    int pisteCounter = 1;

    for (var groupe in groupes) {
      for (int i = 0; i < groupe.length; i++) {
        for (int j = i + 1; j < groupe.length; j++) {
          matchs.add(
            Match(
              id: IDGenerator.generateID('match'),
              joueur1: groupe[i],
              joueur2: groupe[j],
              piste: pisteCounter,
              scoreJoueur1: 0,
              scoreJoueur2: 0,
            ),
          );
        }
      }
      pisteCounter++;
    }
    return matchs;
  }

  /// Génère la phase éliminatoire
  void genererPhaseEliminatoire(String tournoiId) {
    final index = _tournois.indexWhere((t) => t.id == tournoiId);
    if (index == -1) return;

    final tournoi = _tournois[index];

    // Étape 1 : Déterminer les joueurs qualifiés (2 premiers de chaque groupe)
    final joueursQualifies = <String>[];
    for (var groupe in tournoi.groupes) {
      final classement = _calculerClassement(groupe, tournoi.matchs);
      joueursQualifies.addAll(classement.take(2).map((e) => e['joueur'] as String));
    }
    tournoi.joueursQualifies = joueursQualifies;

    // Étape 2 : Générer les matchs éliminatoires
    final matchsEliminatoires = <Match>[];
    final nombreQualifies = joueursQualifies.length;

    // Si le nombre de qualifiés n'est pas une puissance de 2, ajouter des "byes"
    final prochainePuissanceDeDeux = (nombreQualifies > 1)
        ? (1 << (nombreQualifies - 1).bitLength)
        : 1;

    while (joueursQualifies.length < prochainePuissanceDeDeux) {
      joueursQualifies.add('BYE'); // Ajout de joueurs fictifs pour équilibrer
    }

    // Créer les matchs de la phase éliminatoire
    for (int i = 0; i < joueursQualifies.length ~/ 2; i++) {
      final joueur1 = joueursQualifies[i];
      final joueur2 = joueursQualifies[joueursQualifies.length - 1 - i];

      if (joueur1 != 'BYE' && joueur2 != 'BYE') {
        matchsEliminatoires.add(
          Match(
            id: IDGenerator.generateID('match'),
            joueur1: joueur1,
            joueur2: joueur2,
            piste: i + 1,
            scoreJoueur1: 0,
            scoreJoueur2: 0,
          ),
        );
      }
    }

    tournoi.matchsEliminatoires = matchsEliminatoires;
    notifyListeners();
  }



  /// Classement des joueurs dans un groupe
  List<Map<String, dynamic>> _calculerClassement(
      List<String> joueurs, List<Match> matchs) {
    final classement = <String, Map<String, dynamic>>{};

    // Initialisation des joueurs dans le classement
    for (final joueur in joueurs) {
      classement[joueur] = {'joueur': joueur, 'manches': 0, 'points': 0};
    }

    // Mise à jour des statistiques des joueurs en fonction des matchs
    for (final match in matchs) {
      if (classement.containsKey(match.joueur1)) {
        classement[match.joueur1]!['manches'] += match.manchesJoueur1;
        classement[match.joueur1]!['points'] += match.scoreJoueur1;
      }
      if (classement.containsKey(match.joueur2)) {
        classement[match.joueur2]!['manches'] += match.manchesJoueur2;
        classement[match.joueur2]!['points'] += match.scoreJoueur2;
      }
    }

    // Trie par manches gagnées, puis par points en cas d'égalité
    final classementListe = classement.values.toList();
    classementListe.sort((a, b) {
      final manchesDiff = b['manches'] - a['manches'];
      if (manchesDiff != 0) return manchesDiff;
      return b['points'] - a['points'];
    });

    return classementListe;
  }


  /// Modifie les scores d'un match
  void modifierScore({
    required String tournoiId,
    required int matchIndex,
    required int scoreJoueur1,
    required int scoreJoueur2,
  }) {
    final tournoiIndex = _tournois.indexWhere((t) => t.id == tournoiId);
    if (tournoiIndex == -1) return;

    final tournoi = _tournois[tournoiIndex];

    if (matchIndex >= 0 && matchIndex < tournoi.matchs.length) {
      final match = tournoi.matchs[matchIndex];
      match.scoreJoueur1 = scoreJoueur1;
      match.scoreJoueur2 = scoreJoueur2;
      notifyListeners();
    }
  }

  /// Retourne un tournoi par son ID ou null s'il n'existe pas
  Tournoi? obtenirTournoiParId(String id) {
    try {
      return _tournois.firstWhere((tournoi) => tournoi.id == id);
    } catch (e) {
      return null; // Retourne null si aucun tournoi n'est trouvé
    }
  }

}
