import "dart:typed_data";
import "package:device_info_plus/device_info_plus.dart";
import "package:flutter/material.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/services.dart";
import "package:permission_handler/permission_handler.dart";
import "package:trilhas_phb/services/hike.dart";
import "package:trilhas_phb/models/file.dart";
import "package:trilhas_phb/widgets/decorated_label.dart";
import "package:trilhas_phb/widgets/decorated_text_form_field.dart";
import "package:trilhas_phb/widgets/future_button.dart";

class HikeRegisterScreen extends StatefulWidget {
  const HikeRegisterScreen({super.key});

  @override
  State<HikeRegisterScreen> createState() => _HikeRegisterScreenState();
}

class _HikeRegisterScreenState extends State<HikeRegisterScreen> {
  final HikeService _hikeService = HikeService();

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _lengthController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _difficulty = "";
  bool _isEasySelected = false;
  bool _isMedioSelected = false;
  bool _isDificilSelected = false;

  FileModel? _gpxFile;

  List<FileModel> _selectedImages = [];

  Future<void> _pickGpx() async {
    try {
      if (_gpxFile != null) {
        setState(() {
          _gpxFile = null;
        });

        return;
      }

      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final storageStatus = androidInfo.version.sdkInt < 33
          ? await Permission.storage.request()
          : PermissionStatus.granted;

      if (storageStatus == PermissionStatus.permanentlyDenied) {
        openAppSettings();
      }

      if (storageStatus != PermissionStatus.granted) {
        if (!mounted) return;

        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text(
                "Permissão de armazenamento necessária para selecionar o arquivo GPX.",
              ),
            ),
          );

        return;
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        withData: true,
      );

      if (result == null) {
        if (!mounted) return;

        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
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
        if (!mounted) return;

        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text(
                "Arquivo não possui a extensão correta.",
              ),
            ),
          );

        return;
      }

      if (file.size > 40000000) {
        if (!mounted) return;

        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text(
                "O tamanho do GPX é maior do que o permitido (40MB).",
              ),
            ),
          );

        return;
      }

      final convertedFile = FileModel(
        bytes: Uint8List.fromList(
          file.bytes!,
        ),
        filename: file.name,
      );

      setState(() {
        _gpxFile = convertedFile;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              "Erro ao modificar o arquivo GPX: ${e.toString().replaceAll("Exception: ", "")}",
            ),
          ),
        );
    }
  }

  Future<void> _pickImages() async {
    try {
      if (_selectedImages.length == 5) {
        if (!mounted) return;

        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text(
                "O número máximo de imagens permitido é 5.",
              ),
            ),
          );

        return;
      }

      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final storageStatus = androidInfo.version.sdkInt < 33
          ? await Permission.storage.request()
          : PermissionStatus.granted;

      if (storageStatus == PermissionStatus.permanentlyDenied) {
        openAppSettings();
      }

      if (storageStatus != PermissionStatus.granted) {
        if (!mounted) return;

        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text(
                "Permissão de armazenamento necessária para selecionar imagens.",
              ),
            ),
          );

        return;
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.image,
        withData: true,
      );

      if (result == null) {
        if (!mounted) return;

        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text(
                "Selecione alguma imagem.",
              ),
            ),
          );

        return;
      }

      if ((result.files.length + _selectedImages.length) > 5) {
        if (!mounted) return;

        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text(
                "São permitidas apenas 5 imagens.",
              ),
            ),
          );

        return;
      }

      final convertedImages = result.files
          .map(
            (file) => FileModel(
              bytes: file.bytes!,
              filename: file.name,
            ),
          )
          .toList();

      setState(() {
        _selectedImages.addAll(convertedImages);
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              "Erro ao adicionar imagem(ns): ${e.toString().replaceAll("Exception: ", "")}",
            ),
          ),
        );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_difficulty == "") {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              "Para se cadastrar a trilha, é necessário definir a sua dificuldade.",
            ),
          ),
        );
      return;
    }

    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              "Para se cadastrar a trilha, é necessário possuir pelo menos uma imagem.",
            ),
          ),
        );
      return;
    }

    if (_selectedImages.length > 5) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              "O número máximo de imagens permitidas é 5.",
            ),
          ),
        );
      return;
    }

    if (_gpxFile == null) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              "Para se cadastrar a trilha, é necessário haver o seu arquivo GPX.",
            ),
          ),
        );
      return;
    }

    try {
      await _hikeService.create(
        name: _nameController.text,
        length: double.tryParse(_lengthController.text) ?? 0,
        description: _descriptionController.text,
        difficulty: _difficulty,
        images: _selectedImages,
        gpxFile: _gpxFile!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              "Trilha cadastrada com sucesso!",
            ),
          ),
        );

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              "Erro ao cadastrar trilha: ${e.toString().replaceAll("Exception: ", "")}",
            ),
          ),
        );
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Digite o nome da trilha.";
    }

    return null;
  }

  String? _validateLength(String? value) {
    if (value == null || value.isEmpty) {
      return "Digite a distância da trilha.";
    }

    if (double.tryParse(value) == null) {
      return "Valor inválido.";
    }

    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return "Digite a descrição da trilha.";
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
        resizeToAvoidBottomInset: true, // avoid getting hidden keyboard
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
                    inputFormatters: [LengthLimitingTextInputFormatter(50)],
                  ),
                  const SizedBox(height: 16),
                  const DecoratedLabel(
                    content: "Distância Percorrida (Km)",
                  ),
                  const SizedBox(height: 8),
                  DecoratedTextFormField(
                    textInputType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: _lengthController,
                    hintText: "Digite aqui",
                    validator: _validateLength,
                    inputFormatters: [LengthLimitingTextInputFormatter(16)],
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
                    inputFormatters: [LengthLimitingTextInputFormatter(200)],
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
                            _selectedImages.isNotEmpty
                                ? "${_selectedImages.length} foto(s) adicionada(s)"
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
                          final image = _selectedImages[index];
                          return Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.memory(
                                  image.bytes,
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
                            _gpxFile != null
                                ? "Arquivo GPX adicionado"
                                : "Adicionar arquivo GPX",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: _gpxFile != null
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
                              color: _gpxFile != null
                                  ? Colors.grey
                                  : const Color.fromARGB(255, 3, 204, 107),
                              shape: BoxShape.rectangle,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: Icon(
                              _gpxFile != null ? Icons.close : Icons.add,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FutureButton(
                    future: _handleSubmit,
                    primary: true,
                    text: "Cadastrar",
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
