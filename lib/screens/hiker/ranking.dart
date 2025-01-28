import 'package:flutter/material.dart';
import 'package:trilhas_phb/models/user_data.dart';
import 'package:trilhas_phb/services/user.dart';

class RankingScreen extends StatefulWidget {
  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabela de Classificação'),
      ),
      body: FutureBuilder<List<UserProfileModel>>(
        future: _userService.fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar dados: ${snapshot.error!.toString().replaceAll("Exception: ", "")}'));
          }

          final users = snapshot.data ?? [];

          if (users.isEmpty) {
            return const Center(child: Text('Nenhum usuário encontrado.'));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final rank = index + 1; // Posição no ranking
              return RankingListItem(user: user, rank: rank);
            },
          );
        },
      ),
    );
  }
}

class RankingListItem extends StatelessWidget {
  final UserProfileModel user;
  final int rank;

  const RankingListItem({
    Key? key,
    required this.user,
    required this.rank,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: rank <= 3
          ? Icon(
              Icons.emoji_events,
              color: rank == 1
                  ? Colors.amber
                  : rank == 2
                      ? Colors.grey
                      : Colors.brown,
            )
          : Text('$rank', style: const TextStyle(fontSize: 18)),
      title: Text(user.profileFullName),
      
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.green),
          Text('${user.profileStars}'),
        ],
      ),
    );
  }
}
