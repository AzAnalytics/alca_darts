import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PlayerBarChart extends StatelessWidget {
  final Map<String, int> playerScores;

  const PlayerBarChart({super.key, required this.playerScores});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: _buildBarGroups(),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                try {
                  return Text(
                    playerScores.keys.elementAt(value.toInt()),
                    style: const TextStyle(fontSize: 10),
                  );
                } catch (e) {
                  return const Text('');
                }
              },
              reservedSize: 30,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipPadding: const EdgeInsets.all(8), // Espacement interne
            tooltipRoundedRadius: 8, // Coins arrondis
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final player = playerScores.keys.elementAt(group.x.toInt());
              return BarTooltipItem(
                '$player\n',
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: '${rod.toY.toInt()} points',
                    style: const TextStyle(color: Colors.yellow),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }


  /// Construit les groupes de barres pour chaque joueur
  List<BarChartGroupData> _buildBarGroups() {
    return playerScores.entries.map((entry) {
      final index = playerScores.keys.toList().indexOf(entry.key);
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: Colors.blue,
            width: 16,
          ),
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();
  }
}
