import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trilhas_phb/constants/app_colors.dart';
import 'package:trilhas_phb/screens/administrator/check_user_info.dart';
import 'package:trilhas_phb/services/user.dart'; // Serviço de usuários
import 'package:trilhas_phb/models/user_data.dart';
import 'package:trilhas_phb/widgets/loader.dart'; // Modelo UserProfileModel

class UserListingScreen extends StatefulWidget {
  const UserListingScreen({super.key});

  @override
  State<UserListingScreen> createState() => _UserListingScreenState();
}

class _UserListingScreenState extends State<UserListingScreen> {
  bool _isRegisteredUsersSelected = true;
  bool _isSolicitationUsersSelected = false;

  String _ordenationParam = 'nome';
  bool _ordenationAsc = true;

  List<UserProfileModel> _registeredUsers = [];
  bool _isRegisteredUsersLoading = false;
  String? _isRegisteredUsersLoadingError;

  List<UserProfileModel> _solicitationUsers = [];
  bool _isSolicitationUsersLoading = false;
  String? _isSolicitationUsersLoadingError;

  final _userService = UserService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  void _loadData() {
    Future.wait([
      _loadSolicitationUsers(),
      _loadRegisteredUsers(),
    ]);
  }

  Future<void> _loadSolicitationUsers() async {
    try {
      setState(() {
        _isSolicitationUsersLoading = true;
      });

      List<UserProfileModel> fetchedUsers = await _userService.fetchUsers(
        isAccepted: false,
        orderByName: true,
        orderAsc: _ordenationAsc,
      );

      setState(() {
        _solicitationUsers = fetchedUsers;
        _isSolicitationUsersLoadingError = null;
      });
    } catch (e) {
      setState(() {
        _isSolicitationUsersLoadingError =
            e.toString().replaceAll("Exception: ", "");
      });
    } finally {
      setState(() {
        _isSolicitationUsersLoading = false;
      });
    }
  }

  Future<void> _loadRegisteredUsers() async {
    try {
      setState(() {
        _isRegisteredUsersLoading = true;
      });
      List<UserProfileModel> fetchedUsers = await _userService.fetchUsers(
        isAccepted: true,
        orderByName: (_ordenationParam == 'nome'),
        orderAsc: _ordenationAsc,
      );
      setState(() {
        _registeredUsers = fetchedUsers;
        _isRegisteredUsersLoadingError = null;
      });
    } catch (e) {
      setState(() {
        _isRegisteredUsersLoadingError =
            e.toString().replaceAll("Exception: ", "");
      });
    } finally {
      setState(() {
        _isRegisteredUsersLoading = false;
      });
    }
  }

  void showFilter(BuildContext context) {
    showMenu<dynamic>(
      context: context,
      position: const RelativeRect.fromLTRB(100, 80, 0, 0),
      items: <PopupMenuEntry<dynamic>>[
        if (_isRegisteredUsersSelected)
          PopupMenuItem(
            enabled: false,
            child: Text(
              'Classificar por:',
              style: GoogleFonts.inter(color: AppColors.primary),
            ),
          ),
        if (_isRegisteredUsersSelected)
          PopupMenuItem(
            child: ListTile(
              title: Text('Nome', style: GoogleFonts.inter()),
              leading: Radio(
                value: 'nome',
                groupValue: _ordenationParam,
                activeColor: AppColors.primary,
                onChanged: (value) {
                  setState(() {
                    _ordenationParam = value as String;
                  });
                  Navigator.pop(context);
                  _loadData();
                },
              ),
            ),
          ),
        if (_isRegisteredUsersSelected)
          PopupMenuItem(
            child: ListTile(
              title: Text('Estrela', style: GoogleFonts.inter()),
              leading: Radio(
                value: 'estrelas',
                groupValue: _ordenationParam,
                activeColor: AppColors.primary,
                onChanged: (value) {
                  setState(() {
                    _ordenationParam = value as String;
                  });
                  Navigator.pop(context);
                  _loadData();
                },
              ),
            ),
          ),
        if (_isRegisteredUsersSelected)
          const PopupMenuDivider(),
        PopupMenuItem(
          enabled: false,
          child: Text('Ordenar de forma:',
              style: GoogleFonts.inter(color: AppColors.primary)),
        ),
        // Ordenação Crescente
        PopupMenuItem(
          child: ListTile(
            title: Text('Crescente', style: GoogleFonts.inter()),
            leading: Radio(
              value: true,
              groupValue: _ordenationAsc,
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() {
                  _ordenationAsc = value as bool;
                });
                Navigator.pop(context);
                _loadData();
              },
            ),
          ),
        ),
        // Ordenação Decrescente
        PopupMenuItem(
          child: ListTile(
            title: Text('Decrescente', style: GoogleFonts.inter()),
            leading: Radio(
              value: false,
              groupValue: _ordenationAsc,
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() {
                  _ordenationAsc = value as bool;
                });
                Navigator.pop(context);
                _loadData();
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
      onRefresh: () async {
        _loadData();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Lista de Usuários',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.bold, color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list, color: AppColors.primary),
              onPressed: () {
                showFilter(context);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Botões para alternar entre "USUÁRIOS CADASTRADOS" e "SOLICITAÇÕES"
            Container(
              color: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(100, 40),
                        side: BorderSide(
                          color: _isRegisteredUsersSelected
                              ? Colors.white
                              : const Color.fromARGB(255, 3, 204, 107),
                          width: 2,
                        ),
                        backgroundColor: _isRegisteredUsersSelected
                            ? const Color.fromARGB(255, 3, 204, 107)
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _isRegisteredUsersSelected = true;
                          _isSolicitationUsersSelected = false;
                        });
                      },
                      child: Text(
                        'CADASTRADOS',
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            color: _isRegisteredUsersSelected
                                ? Colors.white
                                : AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(100, 40),
                        side: BorderSide(
                          color: _isSolicitationUsersSelected
                              ? Colors.white
                              : const Color.fromARGB(255, 3, 204, 107),
                          width: 2,
                        ),
                        backgroundColor: _isSolicitationUsersSelected
                            ? const Color.fromARGB(255, 3, 204, 107)
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _isSolicitationUsersSelected = true;
                          _isRegisteredUsersSelected = false;
                        });
                      },
                      child: Text(
                        'SOLICITAÇÕES',
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            color: _isSolicitationUsersSelected
                                ? Colors.white
                                : AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Builder(builder: (context) {
              if (_isSolicitationUsersSelected) {
                return SolicitationUsersScreen(
                  solicitationUsers: _solicitationUsers,
                  isSolicitationUsersLoading: _isSolicitationUsersLoading,
                  isSolicitationUsersLoadingError:
                      _isSolicitationUsersLoadingError,
                  onUpdate: _loadData,
                );
              }
              return RegisteredUsersScreen(
                registeredUsers: _registeredUsers,
                isRegisteredUsersLoading: _isRegisteredUsersLoading,
                isRegisteredUsersLoadingError: _isRegisteredUsersLoadingError,
                onUpdate: _loadData,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class RegisteredUsersScreen extends StatelessWidget {
  const RegisteredUsersScreen({
    super.key,
    required this.registeredUsers,
    required this.isRegisteredUsersLoading,
    required this.isRegisteredUsersLoadingError,
    required this.onUpdate,
  });

  final List<UserProfileModel> registeredUsers;
  final bool isRegisteredUsersLoading;
  final String? isRegisteredUsersLoadingError;
  final void Function() onUpdate;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Builder(
        builder: (context) {
          if (isRegisteredUsersLoading) {
            return const Loader();
          }

          if (isRegisteredUsersLoadingError != null) {
            return Stack(
              children: <Widget>[
                Center(
                  child: Text(isRegisteredUsersLoadingError!),
                ),
                ListView()
              ],
            );
          }

          if (registeredUsers.isEmpty) {
            return Stack(
              children: <Widget>[
                const Center(
                  child: Text("Os usuários cadastrados aparecerão aqui."),
                ),
                ListView()
              ],
            );
          }

          return ListView.builder(
            itemCount: registeredUsers.length,
            itemBuilder: (context, index) {
              final user = registeredUsers[index];
              return UserListTile(
                user: user,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return CheckUserInfoScreen(userData: user);
                    }),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class SolicitationUsersScreen extends StatelessWidget {
  const SolicitationUsersScreen({
    super.key,
    required this.solicitationUsers,
    required this.isSolicitationUsersLoading,
    required this.isSolicitationUsersLoadingError,
    required this.onUpdate,
  });

  final List<UserProfileModel> solicitationUsers;
  final bool isSolicitationUsersLoading;
  final String? isSolicitationUsersLoadingError;
  final void Function() onUpdate;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Builder(
        builder: (context) {
          if (isSolicitationUsersLoading) {
            return const Loader();
          }

          if (isSolicitationUsersLoadingError != null) {
            return Stack(
              children: <Widget>[
                Center(
                  child: Text(isSolicitationUsersLoadingError!),
                ),
                ListView()
              ],
            );
          }

          if (solicitationUsers.isEmpty) {
            return Stack(
              children: <Widget>[
                const Center(
                  child: Text("Os usuários cadastrados aparecerão aqui."),
                ),
                ListView()
              ],
            );
          }

          return ListView.builder(
            itemCount: solicitationUsers.length,
            itemBuilder: (context, index) {
              final user = solicitationUsers[index];
              return UserListTile(
                user: user,
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return CheckUserInfoScreen(userData: user);
                    }),
                  );

                  if (result == null) return;
                  if (!result) return;

                  onUpdate();
                },
              );
            },
          );
        },
      ),
    );
  }
}

class UserListTile extends StatelessWidget {
  const UserListTile({
    super.key,
    required this.user,
    required this.onPressed,
  });

  final UserProfileModel user;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[300],
        child: const Icon(Icons.person, color: AppColors.primary),
      ),
      title: Text(
        user.profileFullName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        children: [
          const Icon(
            FontAwesomeIcons.solidStar,
            color: AppColors.primary,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text('${user.profileStars}'),
        ],
      ),
      trailing: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text('Detalhes', style: GoogleFonts.inter()),
      ),
    );
  }
}
