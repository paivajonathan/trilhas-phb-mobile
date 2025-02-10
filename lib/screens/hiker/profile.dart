import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trilhas_phb/constants/app_colors.dart';
import 'package:trilhas_phb/providers/user_data.dart';
import 'package:trilhas_phb/screens/authentication/login.dart';
import 'package:trilhas_phb/services/auth.dart';
import 'package:trilhas_phb/widgets/alert_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = AuthService();

  Future<void> _handleLogout() async {
    final keepAction = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const DialogWidget(
          title: "Sair",
          content:
              "Você realmente deseja sair? Caso saia, terá que logar novamente para acessar o app.",
          continueText: "Sair",
          isDestructiveAction: true,
        );
      },
    );

    if (keepAction == null) return;
    if (!keepAction) return;

    try {
      await _auth.logout();

      if (!mounted) {
        return;
      }

      await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );

      if (!mounted) {
        return;
      }

      Provider.of<UserDataProvider>(context, listen: false).clearUserData();
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              "Ocorreu um erro ao tentar sair da conta: ${e.toString().replaceAll("Exception: ", "")}",
            ),
          ),
        );
    }
  }

  Future<void> _handleAccountDeletion() async {
    final keepAction = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const DialogWidget(
          title: "Excluir conta",
          content:
              "Você realmente deseja excluir sua conta? Caso exclua, terá que criar uma nova conta para acessar o app.",
          continueText: "Excluir",
          isDestructiveAction: true,
        );
      },
    );

    if (keepAction == null) return;
    if (!keepAction) return;

    try {
      await _auth.inactivateAccount();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text("Conta excluída com sucesso."),
          ),
        );

      await _auth.logout();

      if (!mounted) {
        return;
      }

      await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );

      if (!mounted) {
        return;
      }

      Provider.of<UserDataProvider>(context, listen: false).clearUserData();
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              "Ocorreu um erro ao excluir a sua conta: ${e.toString().replaceAll("Exception: ", "")}",
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context).userData!;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Perfil",
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
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(
          top: 25.0,
          left: 25.0,
          right: 25.0,
          bottom: 25.0,
        ),
        child: Column(
          children: [
            SizedBox(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 45,
                    child: const Icon(
                      Icons.person,
                      size: 75,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData.firstLastName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          userData.userEmail,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2.5,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                userData.profileStars.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              color: Colors.black.withOpacity(.125),
              height: 1.0,
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              child: Text(
                "Sair",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () => _handleLogout(),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              color: Colors.black.withOpacity(.125),
              height: 1.0,
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () => _handleAccountDeletion(),
              child: Text(
                "Excluir conta",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.red),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              color: Colors.black.withOpacity(.125),
              height: 1.0,
            ),
          ],
        ),
      ),
    );
  }
}
