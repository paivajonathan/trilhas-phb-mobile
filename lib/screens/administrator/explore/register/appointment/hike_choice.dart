import 'package:flutter/material.dart';
import 'package:trilhas_phb/screens/administrator/explore/register/appointment/appointment_register.dart';
import 'package:trilhas_phb/services/hike.dart';
import 'package:trilhas_phb/widgets/decorated_list_tile.dart';
import 'package:trilhas_phb/widgets/loader.dart';

class HikeChoiceScreen extends StatelessWidget {
  HikeChoiceScreen({super.key});
  final _hikeService = HikeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Agendar trilha",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.black.withOpacity(.25),
            height: 1.0,
          ),
        ),
        leading: IconButton(
          icon: SizedBox(
            height: 20,
            width: 20,
            child: Image.asset("assets/icon_voltar.png"),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(
          top: 25.0,
          left: 25.0,
          right: 25.0,
          bottom: 25.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Escolha uma trilha",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Escolha a trilha que deseja agendar",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF71727A),
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: FutureBuilder(
                future: _hikeService.getAll(hasActiveAppointments: false, isActive: true),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Loader();
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Ocorreu um erro: ${snapshot.error.toString().replaceAll("Exception: ", "")}",
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
                    itemCount: snapshot.data!.length,
                    separatorBuilder: (context, value) {
                      return const SizedBox(height: 10);
                    },
                    itemBuilder: (context, index) {
                      final hike = snapshot.data![index];
                      return DecoratedListTile(
                        hike: hike,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return AppointmentRegisterScreen(hike: hike);
                              },
                            ),
                          ).then((value) {
                            if (value == null) return;
                            if (value) Navigator.of(context).pop(true);
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
