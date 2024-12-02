import 'package:flutter/material.dart';
import '../models/match.dart';

class MatchTile extends StatelessWidget {
  final Match match;
  final VoidCallback? onTap;

  const MatchTile({super.key, required this.match, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text('${match.joueur1} vs ${match.joueur2}'),
        subtitle: Text('Piste : ${match.piste}'),
        trailing: Text(
          '${match.scoreJoueur1} - ${match.scoreJoueur2}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
