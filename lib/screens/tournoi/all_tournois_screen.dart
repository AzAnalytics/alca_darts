import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tournoi_provider.dart';
import 'create_tournoi_screen.dart';
import 'tournoi_details_screen.dart';

class AllTournoisScreen extends StatelessWidget {
  const AllTournoisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tournois = Provider.of<TournoiProvider>(context).tournois;

    return Scaffold(
      appBar: AppBar(title: const Text('Tous les Tournois')),
      body: tournois.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Aucun tournoi disponible.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateTournoiScreen(),
                  ),
                );
              },
              child: const Text('Créer un tournoi'),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: tournois.length,
        itemBuilder: (context, index) {
          final tournoi = tournois[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(tournoi.nom),
              subtitle: Text('${tournoi.joueurs.length} participants'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      // Modifier le tournoi
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateTournoiScreen(
                            tournoiExistant: tournoi, // Passe le tournoi à modifier
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Supprimer le tournoi
                      Provider.of<TournoiProvider>(context, listen: false)
                          .supprimerTournoi(tournoi.id);
                    },
                  ),
                ],
              ),
              onTap: () {
                // Voir les détails du tournoi
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TournoiDetailsScreen(
                      tournoi: tournoi,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
