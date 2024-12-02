import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tournoi_provider.dart';
import '../../models/tournoi.dart';

class CreateTournoiScreen extends StatefulWidget {
  final Tournoi? tournoiExistant; // Pour modification d'un tournoi existant

  const CreateTournoiScreen({super.key, this.tournoiExistant});

  @override
  CreateTournoiScreenState createState() => CreateTournoiScreenState();
}

class CreateTournoiScreenState extends State<CreateTournoiScreen> {
  final _nomTournoiController = TextEditingController();
  final List<TextEditingController> _joueursControllers = [];
  final _bestOfGroupesController = TextEditingController();
  final _bestOfEliminatoiresController = TextEditingController();
  final _bestOfFinaleController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Préremplit les champs si on modifie un tournoi existant
    if (widget.tournoiExistant != null) {
      _nomTournoiController.text = widget.tournoiExistant!.nom;
      for (final joueur in widget.tournoiExistant!.joueurs) {
        _joueursControllers.add(TextEditingController(text: joueur));
      }
      _bestOfGroupesController.text = widget.tournoiExistant!.bestOfGroupes.toString();
      _bestOfEliminatoiresController.text = widget.tournoiExistant!.bestOfEliminatoires.toString();
      _bestOfFinaleController.text = widget.tournoiExistant!.bestOfFinale.toString();
    }
  }

  @override
  void dispose() {
    _nomTournoiController.dispose();
    for (var controller in _joueursControllers) {
      controller.dispose();
    }
    _bestOfGroupesController.dispose();
    _bestOfEliminatoiresController.dispose();
    _bestOfFinaleController.dispose();
    super.dispose();
  }

  /// Ajoute un nouveau joueur
  void _ajouterJoueur() {
    setState(() {
      _joueursControllers.add(TextEditingController());
    });
  }

  /// Supprime un joueur de la liste
  void _supprimerJoueur(int index) {
    setState(() {
      _joueursControllers[index].dispose();
      _joueursControllers.removeAt(index);
    });
  }

  /// Valide les données du formulaire et crée ou met à jour un tournoi
  void _creerTournoi() {
    final nom = _nomTournoiController.text.trim();
    final joueurs = _joueursControllers
        .map((controller) => controller.text.trim())
        .where((joueur) => joueur.isNotEmpty)
        .toList();

    final bestOfGroupes = int.tryParse(_bestOfGroupesController.text) ?? 0;
    final bestOfEliminatoires = int.tryParse(_bestOfEliminatoiresController.text) ?? 0;
    final bestOfFinale = int.tryParse(_bestOfFinaleController.text) ?? 0;

    if (nom.isEmpty || joueurs.length < 2 || bestOfGroupes <= 0 || bestOfEliminatoires <= 0 || bestOfFinale <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs correctement.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final provider = Provider.of<TournoiProvider>(context, listen: false);

    if (widget.tournoiExistant == null) {
      // Création d'un nouveau tournoi
      provider.ajouterTournoi(
        nom,
        joueurs,
        bestOfGroupes,
        bestOfEliminatoires,
        bestOfFinale,
      );
    } else {
      // Mise à jour d'un tournoi existant
      provider.mettreAJourTournoi(
        widget.tournoiExistant!.id,
        nom,
        joueurs,
        bestOfGroupes,
        bestOfEliminatoires,
        bestOfFinale,
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tournoiExistant == null ? 'Créer un tournoi' : 'Modifier le tournoi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Champ pour le nom du tournoi
            TextField(
              controller: _nomTournoiController,
              decoration: const InputDecoration(
                labelText: 'Nom du tournoi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Champ pour le Best Of (groupes)
            TextField(
              controller: _bestOfGroupesController,
              decoration: const InputDecoration(
                labelText: 'Best of (groupes)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Champ pour le Best Of (éliminatoires)
            TextField(
              controller: _bestOfEliminatoiresController,
              decoration: const InputDecoration(
                labelText: 'Best of (éliminatoires)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Champ pour le Best Of (finale)
            TextField(
              controller: _bestOfFinaleController,
              decoration: const InputDecoration(
                labelText: 'Best of (finale)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Liste dynamique des joueurs
            Expanded(
              child: ListView.builder(
                itemCount: _joueursControllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        // Champ pour le nom d'un joueur
                        Expanded(
                          child: TextField(
                            controller: _joueursControllers[index],
                            decoration: InputDecoration(
                              labelText: 'Nom du joueur ${index + 1}',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Bouton pour supprimer un joueur
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _supprimerJoueur(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Boutons pour ajouter un joueur ou valider le formulaire
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _ajouterJoueur,
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter un joueur'),
                ),
                ElevatedButton.icon(
                  onPressed: _creerTournoi,
                  icon: const Icon(Icons.check),
                  label: const Text('Valider'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
