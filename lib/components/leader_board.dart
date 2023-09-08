import 'package:flutter/material.dart';
import 'package:new_2048/const/colors.dart';

class LeaderBoardWidget extends StatelessWidget {
  final List top10;

  const LeaderBoardWidget({super.key, required this.top10});

  List<String> modifyList() {
    List<String> list = [];

    for (int i = 0; i < top10.length; i++) {
      list.add('${top10[i]}');
    }
    for (int i = 0; i < 10 - top10.length; i++) {
      list.add('no data');
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    List<String> newList = modifyList();

    return Column(
      children: [
        _buildLeaderboardItem(1, newList[0]),
        _buildLeaderboardItem(2, newList[1]),
        _buildLeaderboardItem(3, newList[2]),
        _buildLeaderboardItem(4, newList[3]),
        _buildLeaderboardItem(5, newList[4]),
        _buildLeaderboardItem(6, newList[5]),
        _buildLeaderboardItem(7, newList[6]),
        _buildLeaderboardItem(8, newList[7]),
        _buildLeaderboardItem(9, newList[8]),
        _buildLeaderboardItem(10, newList[9]),
      ],
    );
  }

  Widget _buildLeaderboardItem(int rank, String? score) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Text(
            '$rank.',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: scoreColor,
            ),
          ),
          const SizedBox(width: 8.0),
          Text(
            score ?? 'no score',
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
