
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:trilhas_phb/services/hike.dart';

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

//Classe adquirida do service
class HikeService {
  Future<void> saveTrail({
    required String name,
    required String distance,
    required String description,
    required String difficulty,
    List<PlatformFile>? images,
    PlatformFile? gpxFile,
  }) async {
    print('Trilha salva: $name, $distance, $description, $difficulty');
  }
}

class _CadastroScreenState extends State<CadastroScreen> {
  final HikeService _hikeService = HikeService();

  final _formKey = GlobalKey<FormState>();
  String nome = ''; //Nome da Trilha
  String distancia = '';
  String sobre = '';
  String difficulty = '';

  final FocusNode _nomeFocusNode = FocusNode();
  final FocusNode _distanciaFocusNode = FocusNode();
  final FocusNode _sobreFocusNode = FocusNode();

  Color _nomeBorderColor = Colors.grey;
  Color _distanciaBorderColor = Colors.grey;
  Color _sobreBorderColor = Colors.grey;

  bool _isFacilSelected = false;
  bool _isMedioSelected = false;
  bool _isDificilSelected = false;

  bool _isGpxAdded = false;

  List<PlatformFile> _selectedFiles = []; // Lista de imagens upadas
  int _selectedImagesCount = 0; // incrementa a medida que as imagens são selecionadas

  @override
  void initState() {
    super.initState();

    _nomeFocusNode.addListener(() {
      setState(() {
        _nomeBorderColor = _nomeFocusNode.hasFocus ? Colors.green : const Color.fromARGB(255, 194, 194, 194);
      });
    });

    _distanciaFocusNode.addListener((){
      setState(() {
        _distanciaBorderColor = _distanciaFocusNode.hasFocus ? Colors.green : const Color.fromARGB(255,194,194,194);
      });
    });

    _sobreFocusNode.addListener(() {
      setState(() {
        _sobreBorderColor = _sobreFocusNode.hasFocus ? Colors.green : const Color.fromARGB(255, 194, 194, 194);
      });
    });
  }

  @override
  void dispose() {
    _nomeFocusNode.dispose();
    _distanciaFocusNode.dispose();
    _sobreFocusNode.dispose();
    super.dispose();
  }

  //GPX selection
  Future<void> _pickGpx() async {
    if (!_isGpxAdded) {
      // Quando o botão está no modo "Adicionar"
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        //allowedExtensions: ['gpx'],
      );

      if (result != null) {
        setState(() {
          _isGpxAdded = true;
          print("Arquivo GPX adicionado: ${result.files.first.name}");
        });
      } else {
        print("Nenhum arquivo selecionado");
      }
    } else {
      // Quando o botão está no modo "Excluir"
      setState(() {
        _isGpxAdded = false;
        print("Arquivo GPX removido");
      });
    }
  }


  //Image selection
  Future<void> _pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles( //Select image
      allowMultiple: true,
      type: FileType.image,
    );
    if (result != null) { //Se a imagem for adicionada
      setState(() {
        _selectedFiles.addAll(result.files);  // Adiciona os novos arquivos à lista existente

        _selectedImagesCount = _selectedFiles.length;
      });

      result.files.forEach((file) {
        print("Arquivo selecionado: ${file.name}");
      });

      } else {
        print("Nenhum arquivo selecionado");
      }
    }

    void _removeImage(int index){ //Remove image
      setState(() {
        _selectedFiles.removeAt(index);
        _selectedImagesCount -- ;
      });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, //form's Background Color
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 1),
            Text(
              "Cadastrar trilha",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 1), // Ajusta a posição do subtítulo
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 120
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView( //Rolamento vertical da tela
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 1), // Ajuste inicial
                // Campo Nome Completo
                Text(
                  'Nome da trilha',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  cursorColor: Colors.green,
                  focusNode: _nomeFocusNode,
                  decoration: InputDecoration(
                    hintText: "Digite aqui",
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 194, 194, 194),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(color: _nomeBorderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(color: _nomeBorderColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite o nome';
                    }
                    return null;
                  },
                  onChanged: (value) => nome = value,
                ),
                const SizedBox(height: 20),

                // Campo Data de Aniversário
                Text(
                  'Distância Percorrida',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  cursorColor: Colors.green,
                  focusNode: _distanciaFocusNode,
                  decoration: InputDecoration(
                    hintText: "Digite aqui",
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 194, 194, 194),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(color: _distanciaBorderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(color: _distanciaBorderColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite aqui';
                    }
                    return null;
                  },
                  onChanged: (value) => distancia = value,
                ),
                const SizedBox(height: 20),


                Text(
                  'Nível de dificuldade',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Row( //Espaço de botões
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //Campo de botão de dificuldade - FÁCIL
                SizedBox(
                  width: 100,
                  height: 40,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(100, 40),
                      side: BorderSide(
                        //Se não foi clicado, a cor se mantém; se foi, altera
                        color: _isFacilSelected ? Colors.white : Color.fromARGB(255, 3, 204, 107),
                        width: 2, // Estilo do texto
                      ),
                      backgroundColor: _isFacilSelected ? Color.fromARGB(255, 3, 204, 107) : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                    onPressed: () {
                      setState(() {
                        _isFacilSelected = !_isFacilSelected; //Altera o estado para mudar o botão

                        //Os outros botões se tornam falsos também

                        _isMedioSelected = false;
                        _isDificilSelected = false;
                      });
                      print("Nível Fácil clicado!");
                    },
                    child: Text(
                      "FÁCIL",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _isFacilSelected ? Colors.white : Color.fromARGB(255, 3, 204, 107)  ,
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  width: 100,
                  height: 40,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(100, 40),
                      side: BorderSide(
                        color: _isMedioSelected ? Colors.white :  Color.fromARGB(255, 255, 168, 0),
                        width: 2, // Estilo do texto 
                      ),
                      backgroundColor: _isMedioSelected ? Color.fromARGB(255, 255, 168, 0) : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                    onPressed: () {
                      setState(() {
                        _isMedioSelected = !_isMedioSelected;

                        _isFacilSelected = false;
                        _isDificilSelected = false;
                      });
                      print("Nível Médio clicado!");
                    },
                    child: Text(
                      "MÉDIO",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _isMedioSelected ? Colors.white :  Color.fromARGB(255, 255, 168, 0),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  width: 100,
                  height: 40,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(100, 40),
                      side: BorderSide(
                        color: _isDificilSelected ? Colors.white : Colors.red,
                        width: 2, // Estilo do texto
                      ),
                      backgroundColor: _isDificilSelected ? Colors.red : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                    onPressed: () {
                      setState((){
                        _isDificilSelected = !_isDificilSelected;

                        _isFacilSelected = false;
                        _isMedioSelected = false;
                      });
                      print("Nível Difícil clicado!");
                    },
                    child:  Text(
                      "DIFÍCIL",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _isDificilSelected? Colors.white : Colors.red
                      ),
                    ),
                  ),
                ),
                  
                  ],
                ),
                // Campo Número
                Text(
                  'Sobre',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  cursorColor: Colors.green,
                  focusNode: _sobreFocusNode,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: "Descreva a trilha",
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 194, 194, 194),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(color: _sobreBorderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(color: _sobreBorderColor),
                    ),
                  ),
                  validator: (value) {
                    //if (value == null || value.isEmpty) {
                      //return 'Digite aqui';
                    //}
                    return null;
                  },
                  onChanged: (value) => sobre = value,
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),

                //Select Image button
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.75,
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          topRight: Radius.zero,
                          bottomRight: Radius.zero
                        ),
                        border: Border.all(
                          color: const Color.fromARGB(255, 228, 228, 228),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        _selectedImagesCount > 0
                            ? "$_selectedImagesCount foto(s) adicionada(s)"
                            : "Adicionar fotos da trilha",
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 3, 204, 107),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      child: GestureDetector(
                      onTap: _pickImages,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 3, 204, 107),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.only( 
                            topRight : Radius.circular(10), 
                            bottomRight : Radius.circular(10)
                          )
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                    height: 65,
                    width: 60,
                    ),
                  ],
                ),
                
                const SizedBox(height: 10),
                // Mostrar as imagens selecionadas
                if (_selectedFiles.isNotEmpty)
                  SizedBox(
                    height: 100, // Altura da área de imagens
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedFiles.length,
                      itemBuilder: (context, index) {
                        final file = _selectedFiles[index];
                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(
                                File(file.path!),
                                width: 82,
                                height: 82,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => _removeImage(index),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            )
                          ]
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 10),

                //GPX Selection
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          topRight: Radius.zero,
                          bottomRight: Radius.zero,
                        ),
                        border: Border.all(
                          color: const Color.fromARGB(255, 228, 228, 228),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        _isGpxAdded ? "Arquivo GPX adicionado" : "Adicionar arquivo GPX",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: _isGpxAdded
                              ? Colors.grey // Cor cinza quando o GPX está adicionado
                              : const Color.fromARGB(255, 3, 204, 107),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 65,
                      width: 60,
                      child: GestureDetector(
                        onTap: _pickGpx,
                        child: Container(
                          decoration: BoxDecoration(
                            color: _isGpxAdded
                                ? Colors.grey // Cor cinza para o botão "Excluir"
                                : const Color.fromARGB(255, 3, 204, 107),
                            shape: BoxShape.rectangle,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Icon(
                            _isGpxAdded ? Icons.close : Icons.add, // Ícone muda dinamicamente
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox (height:20),


                //Botão - salvar
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Determinar o nível de dificuldade selecionado
                      String difficulty = '';
                      if (_isFacilSelected) difficulty = 'Fácil';
                      if (_isMedioSelected) difficulty = 'Médio';
                      if (_isDificilSelected) difficulty = 'Difícil';

                      try {
                        await _hikeService.saveTrail(
                          name: nome,
                          distance: distancia,
                          description: sobre,
                          difficulty: difficulty,
                          images: _selectedFiles.isNotEmpty ? _selectedFiles : null,
                          gpxFile: _isGpxAdded ? null : null, // Substituir com o arquivo real
                        );

                        // Mensagem de sucesso
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Trilha cadastrada com sucesso!')),
                        );

                        // Limpar os campos após o envio bem-sucedido
                        setState(() {
                          nome = '';
                          distancia = '';
                          sobre = '';
                          _isFacilSelected = false;
                          _isMedioSelected = false;
                          _isDificilSelected = false;
                          _selectedFiles.clear();
                          _isGpxAdded = false;
                        });

                      } catch (e) {
                        // Mensagem de erro
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erro ao cadastrar trilha: $e')),
                        );
                      }
                    }
                  },
                  child: Text("Salvar"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: const Color.fromARGB(255, 3, 204, 107),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
