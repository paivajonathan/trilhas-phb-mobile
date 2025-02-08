import 'package:flutter/material.dart';
import 'package:trilhas_phb/constants/app_colors.dart';
import 'package:trilhas_phb/models/user_data.dart';
import 'package:trilhas_phb/services/user.dart';
import 'package:trilhas_phb/widgets/alert_dialog.dart';
import 'package:trilhas_phb/widgets/decorated_label.dart';
import 'package:trilhas_phb/widgets/disabled_text_form_field.dart';
import 'package:trilhas_phb/widgets/future_button.dart';

class CheckUserInfoScreen extends StatefulWidget {
  const CheckUserInfoScreen({super.key, required this.userData});

  final UserProfileModel userData;

  @override
  State<CheckUserInfoScreen> createState() => _CheckUserInfoScreenState();
}

class _CheckUserInfoScreenState extends State<CheckUserInfoScreen> {
  final _userService = UserService();

  Future<void> _handleAccept() async {
    final keepAction = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlurryDialogWidget(
          title: "Aceitar acesso",
          content: "Você realmente deseja aceitar a solicitação de ${widget.userData.profileFullName}?",
          continueText: "Aceitar",
        );
      },
    );

    if (keepAction == null) return;
    if (!keepAction) return;

    try {
      await _userService.accept(
        userId: widget.userData.userId,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(content: Text("Usuário aceito com sucesso.")),
        );

      Navigator.of(context).pop(true);
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

  Future<void> _handleRefuse() async {
    final keepAction = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlurryDialogWidget(
          title: "Recusar acesso",
          content: "Você realmente deseja recusar a solicitação de ${widget.userData.profileFullName}?",
          continueText: "Recusar",
          isDestructiveAction: true,
        );
      },
    );

    if (keepAction == null) return;
    if (!keepAction) return;

    try {
      await _userService.refuse(
        userId: widget.userData.userId,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(content: Text("Usuário recusado com sucesso.")),
        );

      Navigator.of(context).pop(true);
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
          "Informações do Usuário",
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
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
              ],
            ),
            const SizedBox(height: 8),
            const DecoratedLabel(content: "Email"),
            const SizedBox(height: 8),
            DisabledTextFormField(
              initialValue: widget.userData.userEmail,
            ),
            const SizedBox(height: 16),
            const DecoratedLabel(content: "Nome Completo"),
            const SizedBox(height: 8),
            DisabledTextFormField(
              initialValue: widget.userData.profileFullName,
            ),
            const SizedBox(height: 16),
            const DecoratedLabel(content: "Data de Aniversário"),
            const SizedBox(height: 8),
            DisabledTextFormField(
              initialValue: widget.userData.readableBirthDate,
            ),
            const SizedBox(height: 16),
            const DecoratedLabel(content: "Bairro"),
            const SizedBox(height: 8),
            DisabledTextFormField(
              initialValue: widget.userData.profileNeighborhoodName,
            ),
            const SizedBox(height: 16),
            const DecoratedLabel(content: "Contato"),
            const SizedBox(height: 8),
            DisabledTextFormField(
              initialValue: widget.userData.readableCellphone,
            ),
            const SizedBox(height: 24),
            if (!widget.userData.userIsAccepted)
              Row(
                children: [
                  Expanded(
                    child: FutureButton(
                      primary: false,
                      text: "ACEITAR",
                      future: _handleAccept,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: FutureButton(
                      primary: false,
                      text: "RECUSAR",
                      future: _handleRefuse,
                      color: Colors.red,
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
