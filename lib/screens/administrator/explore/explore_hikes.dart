import 'package:flutter/material.dart';
import 'package:trilhas_phb/constants/app_colors.dart';
import 'package:trilhas_phb/models/hike.dart';
import 'package:trilhas_phb/screens/administrator/explore/edit/hike/hike_details.dart';
import 'package:trilhas_phb/widgets/decorated_list_tile.dart';
import 'package:trilhas_phb/screens/administrator/explore/register/hike/hike_register.dart';
import 'package:trilhas_phb/widgets/loader.dart';

class ExploreHikesScreen extends StatelessWidget {
  const ExploreHikesScreen({
    super.key,
    required this.hikes,
    required this.isHikesLoading,
    required this.isHikesLoadingError,
    required this.onUpdate,
  });

  final List<HikeModel> hikes;
  final bool isHikesLoading;
  final String? isHikesLoadingError;
  final void Function() onUpdate;

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
                        return const HikeRegisterScreen();
                      },
                    ),
                  ).then((value) {
                    if (value == null) return;
                    if (value) onUpdate();
                  });
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
          child: Builder(
            builder: (context) {
              if (isHikesLoading) {
                return const Loader();
              }

              if (isHikesLoadingError != null) {
                return Center(
                  child: Text(
                    isHikesLoadingError!,
                  ),
                );
              }

              if (hikes.isEmpty) {
                return const Center(
                  child: Text("As trilhas cadastradas aparecerão aqui."),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  onUpdate();
                },
                color: AppColors.primary,
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: hikes.length,
                  separatorBuilder: (context, value) {
                    return const SizedBox(height: 10);
                  },
                  itemBuilder: (context, index) {
                    final hike = hikes[index];
                    return DecoratedListTile(
                      hike: hike,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return HikeDetailsScreen(hikeId: hike.id);
                            },
                          ),
                        ).then((value) {
                          if (value == null) return;
                          if (value) onUpdate();
                        });
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
