import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tournoi_provider.dart';
import 'create_tournoi_screen.dart';
import 'tournoi_details_screen.dart';

class TournoiListScreen extends StatelessWidget {
  const TournoiListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tous les Tournois'),
      ),
      body: Consumer<TournoiProvider>(
        builder: (context, tournoiProvider, child) {
          final tournois = tournoiProvider.tournois;

          if (tournois.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Aucun tournoi disponible.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Naviguer vers l'écran de création de tournoi
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
            );
          }

          return ListView.builder(
            itemCount: tournois.length,
            itemBuilder: (context, index) {
              final tournoi = tournois[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(tournoi.nom),
                  subtitle: Text('Participants : ${tournoi.joueurs.length}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Naviguer vers l'écran de modification du tournoi
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CreateTournoiScreen(tournoiExistant: tournoi),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Confirmer la suppression
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Supprimer le tournoi'),
                              content: const Text(
                                  'Êtes-vous sûr de vouloir supprimer ce tournoi ?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Annuler'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    tournoiProvider.supprimerTournoi(tournoi.id);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Supprimer'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    // Naviguer vers les détails du tournoi
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TournoiDetailsScreen(tournoi: tournoi),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Naviguer vers l'écran de création de tournoi
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateTournoiScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
