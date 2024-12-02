import 'package:flutter/material.dart';
import '../../models/match.dart';

class MatchScreen extends StatefulWidget {
  final Match match;
  final String tournoiId;

  const MatchScreen({super.key, required this.match, required this.tournoiId});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  int currentPlayer = 0; // 0 pour joueur1, 1 pour joueur2
  int flechettes = 3; // Nombre de fléchettes restantes
  final List<Map<String, dynamic>> historique = [];
  bool isDouble = false;
  bool isTriple = false;

  /// Ajoute un score en tenant compte des multiplicateurs
  void _ajouterScore(int points) {
    setState(() {
      int pointsCalcules = points;
      if (isDouble) {
      pointsCalcules *= 2;
      } else if (isTriple) {
      pointsCalcules *= 3;
      }

      historique.add({'joueur': currentPlayer, 'points': pointsCalcules});

      if (currentPlayer == 0) {
      widget.match.scoreJoueur1 += pointsCalcules;
      } else {
      widget.match.scoreJoueur2 += pointsCalcules;
      }

      // Réinitialiser Double et Triple après utilisation
      isDouble = false;
      isTriple = false;

      // Réduire les fléchettes restantes
      flechettes--;
      if (flechettes == 0) {
      flechettes = 3;
      currentPlayer = currentPlayer == 0 ? 1 : 0;
      }
    });
  }

  /// Bouton Retour pour annuler le dernier score
  void _retirerDernierScore() {
    setState(() {
      if (historique.isEmpty) return;

      final derniereFlechette = historique.removeLast();
      final joueur = derniereFlechette['joueur'] as int; // Assurez-vous que 'joueur' est un entier
      final points = derniereFlechette['points'] as int; // Convertir 'points' en int si nécessaire

      // Met à jour les scores en fonction du joueur
      if (joueur == 0) {
        widget.match.scoreJoueur1 -= points;
      } else {
        widget.match.scoreJoueur2 -= points;
      }

      // Gestion du joueur actif
      if (joueur != currentPlayer) {
        currentPlayer = joueur;
        flechettes = 1; // Revenir à une fléchette restante pour ce joueur
      } else {
        flechettes = (flechettes == 3) ? 1 : flechettes + 1;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Match: ${widget.match.joueur1} vs ${widget.match.joueur2}'),
      ),
      body: Column(
        children: [
          _buildScoreRow(),
          const Divider(),
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildScoreRow() {
    return Row(
      children: [
        Expanded(
          child: _buildPlayerScore(
            widget.match.joueur1,
            widget.match.scoreJoueur1,
            currentPlayer == 0,
          ),
        ),
        Expanded(
          child: _buildPlayerScore(
            widget.match.joueur2,
            widget.match.scoreJoueur2,
            currentPlayer == 1,
          ),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(21, (index) {
            final displayNumber = index == 20 ? 25 : index; // Inclut 0 et 25
            return ElevatedButton(
              onPressed: () => _ajouterScore(displayNumber),
              child: Text(displayNumber.toString()),
            );
          }),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isDouble = true;
                  isTriple = false;
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('DOUBLE'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isTriple = true;
                  isDouble = false;
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('TRIPLE'),
            ),
            ElevatedButton(
              onPressed: _retirerDernierScore,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
              child: const Text('RETOUR'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlayerScore(String joueur, int score, bool isCurrent) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrent ? Colors.blue.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(joueur, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(score.toString(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
