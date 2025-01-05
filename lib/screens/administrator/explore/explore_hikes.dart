import 'package:flutter/material.dart';
import 'package:trilhas_phb/constants/app_colors.dart';
import 'package:trilhas_phb/services/hike.dart';
import 'package:trilhas_phb/widgets/decorated_list_tile.dart';
import 'package:trilhas_phb/screens/administrator/explore/register/hike/hike_register.dart';
import 'package:trilhas_phb/widgets/loader.dart';

class ExploreHikesScreen extends StatefulWidget {
  const ExploreHikesScreen({super.key});

  @override
  State<ExploreHikesScreen> createState() => _ExploreHikesScreenState();
}

class _ExploreHikesScreenState extends State<ExploreHikesScreen> {
  final _hikeService = HikeService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Trilhas cadastradas",
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return HikeRegisterScreen();
                      },
                    ),
                  ).then((value) => setState(() {}));
                },
                child: const Text(
                  "Cadastrar trilha",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: _hikeService.getAll(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    snapshot.error!.toString().replaceAll("Exception: ", ""),
                  ),
                );
              }

              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("As trilhas cadastradas aparecerão aqui."),
                );
              }

              return ListView.separated(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: snapshot.data!.length,
                separatorBuilder: (context, value) {
                  return const SizedBox(height: 10);
                },
                itemBuilder: (context, index) {
                  final hike = snapshot.data![index];
                  return DecoratedListTile(
                    hike: hike,
                    onTap: () {
                      print("Navegando para tela de edição");
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
