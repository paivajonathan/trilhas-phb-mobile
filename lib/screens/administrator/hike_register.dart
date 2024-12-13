import "dart:io";
import "dart:typed_data";
import "package:flutter/material.dart";
import "package:file_picker/file_picker.dart";
import "package:trilhas_phb/services/hike.dart";
import "package:trilhas_phb/models/file.dart";
import "package:trilhas_phb/widgets/decorated_button.dart";
import "package:trilhas_phb/widgets/decorated_label.dart";
import "package:trilhas_phb/widgets/decorated_text_form_field.dart";

class HikeRegisterScreen extends StatefulWidget {
  const HikeRegisterScreen({super.key});

  @override
  State<HikeRegisterScreen> createState() => _HikeRegisterScreenState();
}

class _HikeRegisterScreenState extends State<HikeRegisterScreen> {
  final HikeService _hikeService = HikeService();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _lengthController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _difficulty = "";
  bool _isEasySelected = false;
  bool _isMedioSelected = false;
  bool _isDificilSelected = false;

  bool _isGpxAdded = false;
  PlatformFile? _gpxFile;

  int _selectedImagesCount = 0;
  List<PlatformFile> _selectedImages = [];

  Future<void> _pickGpx() async {
    try {
      if (_isGpxAdded) {
        setState(() {
          _isGpxAdded = false;
          _gpxFile = null;
        });
        return;
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        withData: true,
      );

      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Selecione algum arquivo GPX.",
            ),
          ),
        );
        return;
      }

      final file = result.files.first;

      if (file.extension!.toLowerCase() != "gpx") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Arquivo não possui a extensão correta.",
            ),
          ),
        );
        return;
      }

      setState(() {
        _isGpxAdded = true;
        _gpxFile = file;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Erro ao modificar o arquivo GPX: ${e.toString().replaceAll("Exception: ", "")}",
          ),
        ),
      );
    }
  }

  Future<void> _pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
      withData: true,
    );

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Selecione alguma imagem.",
          ),
        ),
      );
      return;
    }

    setState(() {
      _selectedImages.addAll(result.files);
      _selectedImagesCount = _selectedImages.length;
    });
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
      _selectedImagesCount--;
    });
  }

  Future<void> _handleSubmit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    if (_difficulty == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Para se cadastrar a trilha, é necessário definir a sua dificuldade.",
          ),
        ),
      );
      return;
    }

    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Para se cadastrar a trilha, é necessário possuir pelo menos uma imagem.",
          ),
        ),
      );
      return;
    }

    if (!_isGpxAdded || _gpxFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Para se cadastrar a trilha, é necessário haver o seu arquivo GPX.",
          ),
        ),
      );
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      await _hikeService.create(
        name: _nameController.text,
        length: double.tryParse(_lengthController.text) ?? 0,
        description: _descriptionController.text,
        difficulty: _difficulty,
        images: _selectedImages
            .map(
              (file) => FileModel(
                bytes: file.bytes!,
                filename: file.name,
              ),
            )
            .toList(),
        gpxFile: FileModel(
          bytes: Uint8List.fromList(
            _gpxFile!.bytes!,
          ),
          filename: _gpxFile!.name,
        ),
      );

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Trilha cadastrada com sucesso!",
          ),
        ),
      );

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Erro ao cadastrar trilha: ${e.toString().replaceAll("Exception: ", "")}",
          ),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Digite o nome";
    }

    return null;
  }

  String? _validateLength(String? value) {
    if (value == null || value.isEmpty) {
      return "Digite a distância";
    }

    if (double.tryParse(value) == null) {
      return "Valor inválido";
    }

    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return "Digite a descrição";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Cadastrar Trilha",
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
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  const DecoratedLabel(
                    content: "Nome da trilha",
                  ),
                  const SizedBox(height: 8),
                  DecoratedTextFormField(
                    hintText: "Digite aqui",
                    controller: _nameController,
                    validator: _validateName,
                  ),
                  const SizedBox(height: 16),
                  const DecoratedLabel(
                    content: "Distância Percorrida (km)",
                  ),
                  const SizedBox(height: 8),
                  DecoratedTextFormField(
                    textInputType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: _lengthController,
                    hintText: "Digite aqui",
                    validator: _validateLength,
                  ),
                  const SizedBox(height: 16),
                  const DecoratedLabel(
                    content: "Nível de dificuldade",
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 40,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(100, 40),
                            side: BorderSide(
                              color: _isEasySelected
                                  ? Colors.white
                                  : const Color.fromARGB(255, 3, 204, 107),
                              width: 2,
                            ),
                            backgroundColor: _isEasySelected
                                ? const Color.fromARGB(255, 3, 204, 107)
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _difficulty = "E";
                              _isEasySelected = !_isEasySelected;
                              _isMedioSelected = false;
                              _isDificilSelected = false;
                            });
                          },
                          child: Text(
                            "FÁCIL",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _isEasySelected
                                  ? Colors.white
                                  : const Color.fromARGB(255, 3, 204, 107),
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
                              color: _isMedioSelected
                                  ? Colors.white
                                  : const Color.fromARGB(255, 255, 168, 0),
                              width: 2,
                            ),
                            backgroundColor: _isMedioSelected
                                ? const Color.fromARGB(255, 255, 168, 0)
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _difficulty = "M";
                              _isMedioSelected = !_isMedioSelected;
                              _isEasySelected = false;
                              _isDificilSelected = false;
                            });
                          },
                          child: Text(
                            "MÉDIO",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _isMedioSelected
                                  ? Colors.white
                                  : const Color.fromARGB(255, 255, 168, 0),
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
                              color: _isDificilSelected
                                  ? Colors.white
                                  : Colors.red,
                              width: 2,
                            ),
                            backgroundColor:
                                _isDificilSelected ? Colors.red : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _difficulty = "H";
                              _isDificilSelected = !_isDificilSelected;
                              _isEasySelected = false;
                              _isMedioSelected = false;
                            });
                          },
                          child: Text(
                            "DIFÍCIL",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _isDificilSelected
                                  ? Colors.white
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const DecoratedLabel(
                    content: "Sobre",
                  ),
                  const SizedBox(height: 8),
                  DecoratedTextFormField(
                    maxLines: 5,
                    textInputType: TextInputType.multiline,
                    controller: _descriptionController,
                    validator: _validateDescription,
                    hintText: "Descreva a trilha",
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 10,
                          ),
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
                      ),
                      SizedBox(
                        height: 65,
                        width: 60,
                        child: GestureDetector(
                          onTap: _pickImages,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 3, 204, 107),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_selectedImages.isNotEmpty)
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) {
                          final file = _selectedImages[index];
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
                            ],
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
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
                            _isGpxAdded
                                ? "Arquivo GPX adicionado"
                                : "Adicionar arquivo GPX",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: _isGpxAdded
                                  ? Colors.grey
                                  : const Color.fromARGB(255, 3, 204, 107),
                              fontWeight: FontWeight.bold,
                            ),
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
                                  ? Colors.grey
                                  : const Color.fromARGB(255, 3, 204, 107),
                              shape: BoxShape.rectangle,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: Icon(
                              _isGpxAdded ? Icons.close : Icons.add,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DecoratedButton(
                    onPressed: () => _isLoading ? null : _handleSubmit(context),
                    primary: true,
                    text: "Salvar",
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
