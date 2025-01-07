import 'package:flutter/material.dart';
import 'package:trilhas_phb/constants/app_colors.dart';
import 'package:trilhas_phb/models/hike.dart';
import 'package:trilhas_phb/screens/administrator/explore/edit/hike/hike_edit.dart';
import 'package:trilhas_phb/services/hike.dart';
import 'package:trilhas_phb/widgets/alert_dialog.dart';
import 'package:trilhas_phb/widgets/decorated_button.dart';
import 'package:trilhas_phb/widgets/future_button.dart';
import 'package:trilhas_phb/widgets/map_view.dart';

class HikeDetailsScreen extends StatefulWidget {
  const HikeDetailsScreen({
    super.key,
    required this.hikeId,
  });

  final int hikeId;

  @override
  State<HikeDetailsScreen> createState() =>
      _HikeDetailsScreenState();
}

class _HikeDetailsScreenState extends State<HikeDetailsScreen> {
  final _hikeService = HikeService();

  void _reloadScreen() {
    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Informações",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: _hikeService.getOne(hikeId: widget.hikeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error!.toString()),
            );
          }

          if (snapshot.data == null) {
            return const Center(
              child: Text("Não há dados para mostrar."),
            );
          }

          return Stack(
            children: [
              MapView(hike: snapshot.data!),
              BottomDrawer(
                hike: snapshot.data!,
                onUpdate: _reloadScreen,
              ),
            ],
          );
        },
      ),
    );
  }
}

class BottomDrawer extends StatefulWidget {
  const BottomDrawer({
    super.key,
    required this.hike,
    required this.onUpdate,
  });

  final HikeModel hike;
  final void Function() onUpdate;

  @override
  State<BottomDrawer> createState() => _BottomDrawerState();
}

class _BottomDrawerState extends State<BottomDrawer> {
  final double _maxHeight = 0.7;
  final double _minHeight = 0.075;

  final _hikeService = HikeService();

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;

    super.setState(fn);
  }

  Future<void> _handleInactivate() async {
    final keepAction = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const BlurryDialogWidget(
          title: "Deseja continuar?",
          content: "Tem certeza de que deseja continuar?",
        );
      },
    );

    if (!keepAction) {
      return;
    }

    try {
      await _hikeService.inactivate(
        hikeId: widget.hike.id,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(content: Text("Agendamento inativado com sucesso!")),
        );

      Navigator.of(context).pop();
    } catch (e) {
      final message = e.toString().replaceAll("Exception: ", "");

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(content: Text(message)),
        );
    }
  }

  Future<void> _handleEdit() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return HikeEditScreen(hike: widget.hike);
        },
      ),
    );

    widget.onUpdate();
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.hike.name;
    String length = widget.hike.length.toString();
    String difficulty = widget.hike.readableDifficulty;
    String description = widget.hike.description;

    return DraggableScrollableSheet(
      minChildSize: _minHeight,
      maxChildSize: _maxHeight,
      initialChildSize: _maxHeight,
      snapSizes: [_minHeight, _maxHeight],
      snap: true,
      builder: (_, controller) {
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 250,
                      child: PageView.builder(
                        itemCount: widget.hike.images.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final image =
                              widget.hike.images[index];

                          return Stack(
                            children: [
                              FadeInImage.assetNetwork(
                                placeholder: "assets/loading.gif",
                                image: image.url,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Image.asset(
                                    "assets/placeholder.png",
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  color: Colors.black.withOpacity(.25),
                                  width: double.infinity,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Container(
                      height: 50,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Container(
                        width: 100.0,
                        height: 10.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 25),
                      Text("DISTÂNCIA: $length"),
                      Text("DIFICULDADE: $difficulty KM"),
                      const SizedBox(height: 25),
                      const Text("SOBRE"),
                      Text(description),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Expanded(
                        child: DecoratedButton(
                          primary: true,
                          text: "EDITAR",
                          onPressed: () => _handleEdit(),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: FutureButton(
                          primary: false,
                          text: "INATIVAR",
                          future: _handleInactivate,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
