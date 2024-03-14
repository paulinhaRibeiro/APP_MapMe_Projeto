import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  final File? storedImageSalva1;
  final File? storedImageSalva2;

  const ImageInput(
      {Key? key,
      required this.onSelectImage,
      required this.storedImageSalva1,
      required this.storedImageSalva2})
      : super(key: key);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  final imagePicker = ImagePicker();

  File? _storedImage1;
  File? _storedImage2;

  _takePicture(ImageSource source, int index) async {
    final imageFile = await imagePicker.pickImage(
      source: source,
      maxWidth: 600,
      maxHeight: 600,
    );

    if (imageFile == null) return;

    // Para pegar a pasta que pode armazenar docs na aplicação
    final appDir = await syspaths.getApplicationDocumentsDirectory();

    setState(() {
      if (index == 1) {
        _storedImage1 = File(imageFile.path);
      } else if (index == 2) {
        _storedImage2 = File(imageFile.path);
      }
    });

    // Para salvar a primeira imagem
    if (index == 1) {
      String fileName = path.basename(_storedImage1!.path);
      final savedImage = await _storedImage1!.copy(
        '${appDir.path}/$fileName',
      );
      widget.onSelectImage(pickedImage: savedImage, indexImg: 1);
    } // Para salvar a segunda imagem
    else if (index == 2) {
      // Para pegar a pasta que pode armazenar docs na aplicação
      String fileName2 = path.basename(_storedImage2!.path);
      final savedImage2 = await _storedImage2!.copy(
        '${appDir.path}/$fileName2',
      );
      widget.onSelectImage(pickedImage: savedImage2, indexImg: 2);
    }
  }

  void _showOpcoesBottomSheet(int index) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //
              // Galeria
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      Icons.add_photo_alternate,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Galeria',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _takePicture(ImageSource.gallery, index);
                },
              ),

              //
              // Câmera
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      Icons.add_a_photo,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Câmera',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _takePicture(ImageSource.camera, index);
                },
              ),

              //
              // Remover
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      Icons.delete,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Remover',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    if (index == 1) {
                      widget.onSelectImage(
                          pickedImage: null, indexImg: 1, apagar: true);
                      _storedImage1 = null;
                    } else if (index == 2) {
                      widget.onSelectImage(
                          pickedImage: null, indexImg: 2, apagar: true);
                      _storedImage2 = null;
                    }
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Primeira imagem
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey[200],
                    child: CircleAvatar(
                      radius: 65,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: widget.storedImageSalva1 != null
                          ? FileImage(widget.storedImageSalva1!)
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: IconButton(
                        onPressed: () => _showOpcoesBottomSheet(1),
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Segunda Imagem
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey[200],
                    child: CircleAvatar(
                      radius: 65,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: widget.storedImageSalva2 != null
                          ? FileImage(widget.storedImageSalva2!)
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: IconButton(
                        onPressed: () => _showOpcoesBottomSheet(2),
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
