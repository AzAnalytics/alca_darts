import 'package:alca_darts/screens/match_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/tournoi.dart';
import '../../models/match.dart';
import '../../providers/tournoi_provider.dart';

class TournoiDetailsScreen extends StatelessWidget {
  final Tournoi tournoi;


  const TournoiDetailsScreen({super.key, required this.tournoi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tournoi.nom),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Matchs de la phase de groupes
            if (tournoi.matchs.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Matchs de la phase de groupes :',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...tournoi.matchs.map((match) => _buildMatchCard(context, match)),
                  const SizedBox(height: 16),
                ],
              ),


            // Joueurs qualifiés pour la phase éliminatoire
            if (tournoi.joueursQualifies.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Joueurs qualifiés pour la phase éliminatoire :',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...tournoi.joueursQualifies.map((joueur) => Text(joueur)),
                  const SizedBox(height: 16),
                ],
              ),


            // Matchs de la phase éliminatoire
            if (tournoi.matchsEliminatoires.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Matchs de la phase éliminatoire :',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...tournoi.matchsEliminatoires.map((match) => _buildMatchCard(context, match)),
                ],
              ),
            // Bouton pour générer la phase éliminatoire
            if (tournoi.joueursQualifies.isEmpty)
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Provider.of<TournoiProvider>(context, listen: false)
                        .genererPhaseEliminatoire(tournoi.id);
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Générer la phase éliminatoire'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Construction d'une carte pour un match
  Widget _buildMatchCard(BuildContext context, Match match) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text('${match.joueur1} vs ${match.joueur2}'),
        subtitle: Text('Piste : ${match.piste}'),
        trailing: Text(
          '${match.scoreJoueur1} - ${match.scoreJoueur2}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () {
          // Redirige vers le tableau de scorage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MatchScreen(
                match: match,
                tournoiId: tournoi.id,
              ),
            ),
          );
        },
      ),

    );
  }
}
