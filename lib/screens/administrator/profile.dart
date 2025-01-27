import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  }

  Future<void> _handleAccountDeletion() async {
    final keepAction = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const BlurryDialogWidget(
          title: "Deseja continuar?",
          content: "Tem certeza de que deseja excluir a sua conta?",
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
        ..showSnackBar(const SnackBar(
          content: Text("Conta excluída com sucesso."),
        ));

      await _handleLogout();
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
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            SizedBox(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Icon(Icons.person, size: 75),
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
