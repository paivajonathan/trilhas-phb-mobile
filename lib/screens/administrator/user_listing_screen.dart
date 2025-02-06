import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trilhas_phb/services/user.dart';         // Serviço de usuários
import 'package:trilhas_phb/models/user_data.dart';       // Modelo UserProfileModel

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ListaUsuariosScreen(),
    );
  }
}

class ListaUsuariosScreen extends StatefulWidget {
  @override
  _ListaUsuariosScreenState createState() => _ListaUsuariosScreenState();
}

class UsuariosSolicitadosScreen extends StatefulWidget {
  @override
  _UsuariosSolicitadosScreenState createState() =>
      _UsuariosSolicitadosScreenState();
}

class _UsuariosSolicitadosScreenState extends State<UsuariosSolicitadosScreen> {
  // Para a aba "SOLICITAÇÕES", vamos buscar os usuários solicitados via service
  List<UserProfileModel> usuariosSolicitados = [];
  bool _isLoadingSolicitados = true;
  
  String criterioOrdenacao = 'nome';
  bool crescente = true;

  void carregarUsuariosSolicitados() async {
    try {
      UserService service = UserService();
      // Para solicitações, usamos isAccepted: false (ou o valor correspondente à solicitação)
      List<UserProfileModel> fetchedUsers = await service.fetchUsers(
        isAccepted: false,
        orderByName: (criterioOrdenacao == 'nome'),
        orderAsc: crescente,
      );
      setState(() {
        usuariosSolicitados = fetchedUsers;
        _isLoadingSolicitados = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingSolicitados = false;
      });
      print("Erro ao buscar usuários solicitados: $e");
    }
  }

  // Atualiza a ordenação (recarrega os dados do service)
  void atualizarOrdenacaoSolicitados() {
    setState(() {
      _isLoadingSolicitados = true;
    });
    carregarUsuariosSolicitados();
  }

  // Filtro para a aba de solicitações
  void mostrarFiltroSolicitados(BuildContext context) {
    showMenu<dynamic>(
      context: context,
      position: RelativeRect.fromLTRB(100, 80, 0, 0),
      items: <PopupMenuEntry<dynamic>>[
        PopupMenuItem(
          child: Text(
            'Classificar por:',
            style: GoogleFonts.inter(color: Colors.green),
          ),
          enabled: false,
        ),
        PopupMenuItem(
          child: ListTile(
            title: Text('Nome', style: GoogleFonts.inter()),
            leading: Radio(
              value: 'nome',
              groupValue: criterioOrdenacao,
              activeColor: Colors.green,
              onChanged: (value) {
                setState(() {
                  criterioOrdenacao = value as String;
                });
                Navigator.pop(context);
                atualizarOrdenacaoSolicitados();
              },
            ),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            title: Text('Estrela', style: GoogleFonts.inter()),
            leading: Radio(
              value: 'estrelas',
              groupValue: criterioOrdenacao,
              activeColor: Colors.green,
              onChanged: (value) {
                setState(() {
                  criterioOrdenacao = value as String;
                });
                Navigator.pop(context);
                atualizarOrdenacaoSolicitados();
              },
            ),
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          child: Text('Ordenar de forma:', style: GoogleFonts.inter(color: Colors.green)),
          enabled: false,
        ),
        PopupMenuItem(
          child: ListTile(
            title: Text('Crescente', style: GoogleFonts.inter()),
            leading: Radio(
              value: true,
              groupValue: crescente,
              activeColor: Colors.green,
              onChanged: (value) {
                setState(() {
                  crescente = value as bool;
                });
                Navigator.pop(context);
                atualizarOrdenacaoSolicitados();
              },
            ),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            title: Text('Decrescente', style: GoogleFonts.inter()),
            leading: Radio(
              value: false,
              groupValue: crescente,
              activeColor: Colors.green,
              onChanged: (value) {
                setState(() {
                  crescente = value as bool;
                });
                Navigator.pop(context);
                atualizarOrdenacaoSolicitados();
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    carregarUsuariosSolicitados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  _isLoadingSolicitados
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Botão de filtro para solicitações (opcional, você pode adicionar na AppBar ou onde preferir)
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.filter_list, color: Colors.green),
                    onPressed: () => mostrarFiltroSolicitados(context),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: usuariosSolicitados.length,
                    itemBuilder: (context, index) {
                      final usuario = usuariosSolicitados[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          child: Icon(Icons.person, color: Colors.green),
                        ),
                        title: Text(usuario.profileFullName,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Row(
                          children: [
                            Icon(FontAwesomeIcons.solidStar, color: Colors.green, size: 16),
                            SizedBox(width: 4),
                            Text('${usuario.profileStars}'),
                          ],
                        ),
                        trailing: OutlinedButton(
                          onPressed: () {},
                          child: Text('Detalhes', style: GoogleFonts.inter()),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green,
                            side: BorderSide(color: Colors.green),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class _ListaUsuariosScreenState extends State<ListaUsuariosScreen> {
  bool _isUsariosCadastradosSelected = true;
  bool _isUsuariosSolicitadosSelected = false;

  // Lista de usuários reais (obtida do service) para a aba de cadastrados
  List<UserProfileModel> usuarios = [];
  bool _isLoading = true;

  // Parâmetros para ordenação
  String criterioOrdenacao = 'nome';
  bool crescente = true;

  // Carrega os usuários cadastrados do service
  void carregarUsuarios() async {
    try {
      UserService service = UserService();
      List<UserProfileModel> fetchedUsers = await service.fetchUsers(
        isAccepted: true,
        orderByName: (criterioOrdenacao == 'nome'),
        orderAsc: crescente,
      );
      setState(() {
        usuarios = fetchedUsers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Erro ao buscar usuários: $e");
    }
  }

  // Atualiza a ordenação para cadastrados (recarrega os dados)
  void atualizarOrdenacao() {
    setState(() {
      _isLoading = true;
    });
    carregarUsuarios();
  }

  // Filtro (menu pop-up) para usuários cadastrados
  void mostrarFiltro(BuildContext context, bool isUsuariosCadastrados) {
    showMenu<dynamic>(
      context: context,
      position: RelativeRect.fromLTRB(100, 80, 0, 0),
      items: <PopupMenuEntry<dynamic>>[
        PopupMenuItem(
          child: Text(
            'Classificar por:',
            style: GoogleFonts.inter(color: Colors.green),
          ),
          enabled: false,
        ),
        // Filtro de Nome sempre disponível
        PopupMenuItem(
          child: ListTile(
            title: Text('Nome', style: GoogleFonts.inter()),
            leading: Radio(
              value: 'nome',
              groupValue: criterioOrdenacao,
              activeColor: Colors.green,
              onChanged: (value) {
                setState(() {
                  criterioOrdenacao = value as String;
                });
                Navigator.pop(context);
                atualizarOrdenacao();
              },
            ),
          ),
        ),
        // Filtro de Estrela disponível apenas para usuários cadastrados
        PopupMenuItem(
          child: ListTile(
            title: Text('Estrela', style: GoogleFonts.inter()),
            leading: Radio(
              value: 'estrelas',
              groupValue: criterioOrdenacao,
              activeColor: Colors.green,
              onChanged: (value) {
                setState(() {
                  criterioOrdenacao = value as String;
                });
                Navigator.pop(context);
                atualizarOrdenacao();
              },
            ),
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          child: Text('Ordenar de forma:', style: GoogleFonts.inter(color: Colors.green)),
          enabled: false,
        ),
        // Ordenação Crescente
        PopupMenuItem(
          child: ListTile(
            title: Text('Crescente', style: GoogleFonts.inter()),
            leading: Radio(
              value: true,
              groupValue: crescente,
              activeColor: Colors.green,
              onChanged: (value) {
                setState(() {
                  crescente = value as bool;
                });
                Navigator.pop(context);
                atualizarOrdenacao();
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
              groupValue: crescente,
              activeColor: Colors.green,
              onChanged: (value) {
                setState(() {
                  crescente = value as bool;
                });
                Navigator.pop(context);
                atualizarOrdenacao();
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    carregarUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de Usuários',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(Icons.filter_list, color: Colors.green),
              onPressed: () {
                // Exibe o menu de filtro para cadastrados
                mostrarFiltro(context, _isUsariosCadastradosSelected);
              }),
        ],
      ),
      body: Column(
        children: [
          // Botões para alternar entre "USUÁRIOS CADASTRADOS" e "SOLICITAÇÕES"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(100, 40),
                      side: BorderSide(
                        color: _isUsariosCadastradosSelected ? Colors.white : const Color.fromARGB(255, 3, 204, 107),
                        width: 2,
                      ),
                      backgroundColor: _isUsariosCadastradosSelected ? const Color.fromARGB(255, 3, 204, 107) : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _isUsariosCadastradosSelected = true;
                        _isUsuariosSolicitadosSelected = false;
                      });
                      carregarUsuarios(); // Recarrega os usuários do service
                    },
                    child: Text(
                      'USUÁRIOS CADASTRADOS',
                      style: GoogleFonts.inter(fontSize: 13, color: _isUsariosCadastradosSelected ? Colors.white : Colors.green),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(100, 40),
                      side: BorderSide(
                        color: _isUsuariosSolicitadosSelected ? Colors.white : const Color.fromARGB(255, 3, 204, 107),
                        width: 2,
                      ),
                      backgroundColor: _isUsuariosSolicitadosSelected ? const Color.fromARGB(255, 3, 204, 107) : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _isUsuariosSolicitadosSelected = true;
                        _isUsariosCadastradosSelected = false;
                      });
                      // Carrega os usuários solicitados via service:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UsuariosSolicitadosScreen()),
                      );
                    },
                    child: Text(
                      'SOLICITAÇÕES',
                      style: GoogleFonts.inter(fontSize: 13, color: _isUsuariosSolicitadosSelected ? Colors.white : Colors.green),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isUsariosCadastradosSelected
                ? _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: usuarios.length,
                        itemBuilder: (context, index) {
                          final usuario = usuarios[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              child: Icon(Icons.person, color: Colors.green),
                            ),
                            title: Text(usuario.profileFullName,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Row(
                              children: [
                                Icon(FontAwesomeIcons.solidStar, color: Colors.green, size: 16),
                                SizedBox(width: 4),
                                Text('${usuario.profileStars}'),
                              ],
                            ),
                            trailing: OutlinedButton(
                              onPressed: () {},
                              child: Text('Detalhes', style: GoogleFonts.inter()),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.green,
                                side: BorderSide(color: Colors.green),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          );
                        },
                      )
                : UsuariosSolicitadosScreen(),
          ),
        ],
      ),
    );
  }
}
