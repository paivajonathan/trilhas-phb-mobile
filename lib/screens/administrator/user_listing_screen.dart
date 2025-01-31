import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

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

class _ListaUsuariosScreenState extends State<ListaUsuariosScreen> {
  List<Map<String, dynamic>> usuarios = [
    {'id': 1, 'nome': 'Usuário A', 'estrelas': 8},
    {'id': 2, 'nome': 'Usuário B', 'estrelas': 3},
    {'id': 3, 'nome': 'Usuário C', 'estrelas': 7},
    {'id': 4, 'nome': 'Usuário D', 'estrelas': 1},
    {'id': 5, 'nome': 'Usuário E', 'estrelas': 5},
    {'id': 6, 'nome': 'Usuário F', 'estrelas': 6},
    {'id': 7, 'nome': 'Usuário G', 'estrelas': 4},
    {'id': 8, 'nome': 'Usuário H', 'estrelas': 2},
  ];

  String criterioOrdenacao = 'nome';
  bool crescente = true;

  void ordenarLista() {
    setState(() {
      usuarios.sort((a, b) {
        var valorA = a[criterioOrdenacao];
        var valorB = b[criterioOrdenacao];
        return crescente ? valorA.compareTo(valorB) : valorB.compareTo(valorA);
      });
    });
  }

  void mostrarFiltro(BuildContext context, TapDownDetails details) {
  final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
  showMenu<dynamic>(
    context: context,
    position: RelativeRect.fromRect(
      details.globalPosition & Size(40, 40),
      Offset.zero & overlay.size,
    ),
    items: <PopupMenuEntry<dynamic>>[
        PopupMenuItem(
          child: Text('Classificar por:',
          style: GoogleFonts.inter(color: Colors.green),
          ),
          enabled: false,
        ),
        PopupMenuItem(
          child: ListTile(
            title: Text('Nome',
            style: GoogleFonts.inter(),
            ),
            leading: Radio(
              value: 'nome',
              groupValue: criterioOrdenacao,
              onChanged: (value) {
                setState(() {
                  criterioOrdenacao = value as String;
                  ordenarLista();
                });
                Navigator.pop(context);
              },
            ),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            title: Text('Estrela',
            style: GoogleFonts.inter(),
            ),
            leading: Radio(
              value: 'estrelas',
              groupValue: criterioOrdenacao,
              onChanged: (value) {
                setState(() {
                  criterioOrdenacao = value as String;
                  ordenarLista();
                });
                Navigator.pop(context);
              },
            ),
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          child: Text('Ordenar de forma:',
          style: GoogleFonts.inter(color: Colors.green)
          ),
          enabled: false,
        ),
        PopupMenuItem(
          child: ListTile(
            title: Text('Crescente',
            style: GoogleFonts.inter()
            ),
            leading: Radio(
              value: true,
              groupValue: crescente,
              onChanged: (value) {
                setState(() {
                  crescente = value as bool;
                  ordenarLista();
                });
                Navigator.pop(context);
              },
            ),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            title: Text('Decrescente',
            style: GoogleFonts.inter()
            ),
            leading: Radio(
              value: false,
              groupValue: crescente,
              onChanged: (value) {
                setState(() {
                  crescente = value as bool;
                  ordenarLista();
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
          GestureDetector(
            onTapDown: (details) => mostrarFiltro(context, details),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(Icons.filter_list, color: Colors.green),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('USUÁRIOS CADASTRADOS',
                    style: GoogleFonts.inter()
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('SOLICITAÇÕES',
                    style: GoogleFonts.inter()
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.green),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                final usuario = usuarios[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.person, color: Colors.green),
                  ),
                  title: Text(usuario['nome'], style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Row(
                    children: [
                      Icon(FontAwesomeIcons.solidStar, color: Colors.green, size: 16),
                      SizedBox(width: 4),
                      Text('${usuario['estrelas']}'),
                    ],
                  ),
                  trailing: OutlinedButton(
                    onPressed: () {},
                    child: Text('Detalhes',
                    style: GoogleFonts.inter()
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      side: BorderSide(color: Colors.green),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
