import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trilhas_phb/providers/user_data.dart';
import 'package:flutter/material.dart';
import 'package:trilhas_phb/models/user_data.dart';
import 'package:trilhas_phb/services/user.dart';
import "package:trilhas_phb/constants/app_colors.dart";
import 'package:trilhas_phb/widgets/loader.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final UserService _userService = UserService();

  String ordenationParam = 'nome';
  bool ordenationAsc = true;

  void showFilter(BuildContext context) {
    showMenu<dynamic>(
      context: context,
      position: const RelativeRect.fromLTRB(100, 80, 0, 0),
      items: <PopupMenuEntry<dynamic>>[
        PopupMenuItem(
          enabled: false,
          child: Text(
            'Classificar por:',
            style: GoogleFonts.inter(color: AppColors.primary),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            title: Text('Nome', style: GoogleFonts.inter()),
            leading: Radio(
              value: 'nome',
              groupValue: ordenationParam,
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() {
                  ordenationParam = value as String;
                });
                Navigator.pop(context);
              },
            ),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            title: Text('Estrela', style: GoogleFonts.inter()),
            leading: Radio(
              value: 'estrelas',
              groupValue: ordenationParam,
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() {
                  ordenationParam = value as String;
                });
                Navigator.pop(context);
              },
            ),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          enabled: false,
          child: Text('Ordenar de forma:',
              style: GoogleFonts.inter(color: AppColors.primary)),
        ),
        PopupMenuItem(
          child: ListTile(
            title: Text('Crescente', style: GoogleFonts.inter()),
            leading: Radio(
              value: true,
              groupValue: ordenationAsc,
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() {
                  ordenationAsc = value as bool;
                });
                Navigator.pop(context);
              },
            ),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            title: Text('Decrescente', style: GoogleFonts.inter()),
            leading: Radio(
              value: false,
              groupValue: ordenationAsc,
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() {
                  ordenationAsc = value as bool;
                });
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: Colors.white,
      onRefresh: () async {
        setState(() {});
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list, color: AppColors.primary),
              onPressed: () {
                showFilter(context);
              },
            ),
          ],
          title: const Text(
            "Tabela de Classificação",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: Colors.black.withOpacity(.25),
              height: 1.0,
            ),
          ),
        ),
        body: FutureBuilder<List<UserProfileModel>>(
          future: _userService.fetchUsers(
            isAccepted: true,
            orderByName: (ordenationParam == 'nome'),
            orderAsc: ordenationAsc,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Erro ao carregar dados: ${snapshot.error!.toString().replaceAll("Exception: ", "")}',
                ),
              );
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
      ),
    );
  }
}

class RankingListItem extends StatelessWidget {
  final UserProfileModel user;
  final int rank;

  const RankingListItem({
    super.key,
    required this.user,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserDataProvider>(context).userData;
    final isCurrentUser =
        currentUser != null && currentUser.userId == user.userId;

    return ListTile(
      tileColor: isCurrentUser
          ? const Color.fromARGB(255, 91, 104, 116).withOpacity(0.2)
          : null,
      leading: rank <= 3
          ? Icon(
              Icons.emoji_events,
              color: rank == 1
                  ? Colors.amber
                  : rank == 2
                      ? Colors.grey
                      : Colors.brown,
              size: 28,
            )
          : SizedBox(
              width: 27,
              child: Text(
                '$rank',
                style: const TextStyle(fontSize: 25, color: AppColors.primary),
                textAlign: TextAlign.center,
              ),
            ),
      title: Text(
        user.profileFullName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: AppColors.primary, size: 30),
          Text(
            '${user.profileStars}',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
