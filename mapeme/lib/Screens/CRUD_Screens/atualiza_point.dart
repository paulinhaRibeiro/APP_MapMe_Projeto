import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mapeme/BD/table_point_interest.dart';
import 'package:mapeme/Localization/geolocation_teste.dart';
import 'package:mapeme/Models/point_interest.dart';
import 'package:provider/provider.dart';

import '../Widgets/camera_galeria/image_input.dart';
import '../Widgets/divide_text.dart';
import '../Widgets/text_button.dart';
import '../Widgets/text_field_register.dart';

class AtualizarCadastroPoi extends StatefulWidget {
  final Function(PointInterest) onUpdate;
  // Para quando abrir a tela já ter o obj carregado
  final PointInterest p;

  const AtualizarCadastroPoi(
      {super.key, required this.p, required this.onUpdate});

  @override
  State<AtualizarCadastroPoi> createState() => _AtualizarCadastroPoiState();
}

class _AtualizarCadastroPoiState extends State<AtualizarCadastroPoi>
    with SingleTickerProviderStateMixin {
  // Obtem a instancia da tabela do bd
  var db = GetIt.I.get<ManipuTablePointInterest>();
  // para controlar o TabBar
  late TabController _tabUpdateController;
  // variaveis para pegar o q for digitado nas caixinhas de texto
  final nomeController = TextEditingController();
  final descController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  // Para controlar o evento do clique do usuario
  bool isTouristPoint = false;
  // variaveis para pegar as imagem escolhidas
  File? _pickedImage1;
  File? _pickedImage2;

  // para as variaveis receberem o caminho da imagem
  void _selectImage(
      {File? pickedImage, required int indexImg, bool apagar = false}) {
    setState(() {
      if (indexImg == 1) {
        _pickedImage1 = pickedImage;
      } else if (indexImg == 2) {
        _pickedImage2 = pickedImage;

        // para remover a imagem
      } else if (apagar == true) {
        if (indexImg == 1) {
          _pickedImage1 = pickedImage;
        } else if (indexImg == 2) {
          _pickedImage2 = pickedImage;
        }
      }
    });
  }

  // Função que joga nas caixas de texto o que ja veio do Objeto
  // Isso é chamado sempre que criar a tela
  @override
  void initState() {
    super.initState();
    _tabUpdateController = TabController(length: 2, vsync: this);
    nomeController.text = widget.p.name;
    descController.text = widget.p.description;
    latitudeController.text = widget.p.latitude.toString();
    longitudeController.text = widget.p.longitude.toString();
    _pickedImage1 = widget.p.img1 == "" ? null : File(widget.p.img1);
    _pickedImage2 = widget.p.img2 == "" ? null : File(widget.p.img2);

    // recebe o valor de acordo com o valor do campo do bd
    isTouristPoint = widget.p.turisticPoint == 1 ? true : false;
  }

  _voltarScreen() {
    _aviso("Cadastrado Atualizado com Sucesso");
    Navigator.of(context).pop();
  }

  _aviso(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            msg,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  _atualizarPoi() async {
    var p = PointInterest(
      id: widget.p.id, // recebe o id quando abriu a tela - Construtor
      name: nomeController.text,
      description: descController.text,
      latitude: double.parse(latitudeController.text),
      longitude: double.parse(longitudeController.text),
      img1: _pickedImage1 != null ? _pickedImage1!.path : "",
      img2: _pickedImage2 != null ? _pickedImage2!.path : "",
      // img1: img1Controller.text,
      // img2: img2Controller.text,
      turisticPoint: isTouristPoint ? 1 : 0,
      // receber o valor dela mesmo
      synced: widget.p.synced,
    );
    await db.updatePointInterest(p);
    widget.onUpdate(p);
    _voltarScreen();
  }

  void _submitUpdateForm() {
    // ignore: unused_local_variable
    double posiLat;
    if (nomeController.text.isEmpty ||
        latitudeController.text.isEmpty ||
        longitudeController.text.isEmpty) {
      _aviso("Os Campos Nome, Latitude e Longitude são obrigatórios");
      return;
    }
    try {
      posiLat = double.parse(latitudeController.text);
    } catch (e) {
      _aviso("Por favor, Certifique-se de que o serviço de localização está ativo e aguarde o carregamento.");
      return;
    }
    // chama a função de atualizar
    _atualizarPoi();
  }

  @override
  Widget build(BuildContext context) {
    // local = Provider.of<GeolocationUser>(context);
    // local = context.watch<GeolocationUser>();
    // debugPrint("${local.lat} - ${local.long}");

    return Scaffold(
      appBar: AppBar(
        // retirar o icone da seta que é gerado automaticamente
        automaticallyImplyLeading: false,
        centerTitle: true,

        title: const Text("Editar Ponto de Interesse"),
        bottom: TabBar(
          controller: _tabUpdateController,
          tabs: const [
            Tab(
              icon: Icon(Icons.info),
              text: 'Sobre a Rota',
            ),
            Tab(
              icon: Icon(Icons.location_on),
              text: 'Localização',
            ),
          ],
        ),
      ),
      body: ChangeNotifierProvider<GeolocationUser>(
        create: (context) => GeolocationUser(),
        child: Builder(
          builder: (context) {
            final local = context.watch<GeolocationUser>();

            return TabBarView(
              controller: _tabUpdateController,
              children: [
                Center(
                  child: SingleChildScrollView(
                    
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 10),
                        // campo NOME do ponto de interesse
                        CustomTextField(
                          controller: nomeController,
                          label: "Nome *",
                          maxLength: 50,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Campo Obrigatório!";
                            }
                            return null;
                          },
                        ),

                        // campo DESCRIÇÂO do ponto de interesse
                        CustomTextField(
                          controller: descController,
                          label: "Descrição ",
                          maxLength: 200,
                        ),

                        // Dividir a tela para a parte das imagens
                        const DividerText(text: "Cadastrar Imagem",),
                        // IMAGEM passa uma referencia do metodo para o componente - callback
                        ImageInput(
                          onSelectImage: _selectImage,
                          storedImageSalva1: _pickedImage1,
                          storedImageSalva2: _pickedImage2,
                        ),

                        const SizedBox(height: 5),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 16,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _tabUpdateController.animateTo(
                                      1); // Navegar para a aba "Localização"
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 12,
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 0, 63, 6),
                                  elevation: 10,
                                ),
                                child: const ScreenTextButtonStyle(
                                    text: "Avançar"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ),
                  // ),
                ),

                // segundo campo
                Center(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      child: Center(
                        child: Column(
                          children: [
                            // LATITUDE e LONGITUDE são parametros sem o usuário poder alterar (automatico)
                            // campo LATITUDE do ponto de interesse
                            CustomTextField(
                              controller: latitudeController,
                              label: "Latitude *",
                            ),

                            // Botão para Gerar nova localização
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  if (local.lat == null && local.long == null) {
                                    latitudeController.text = "Carregando...";
                                    longitudeController.text = "Carregando...";
                                  } else {
                                    // Latitude
                                    latitudeController.text = local.erro == ""
                                        ? "${local.lat}"
                                        : local.erro;
                                    // Longitude
                                    longitudeController.text = local.erro == ""
                                        ? "${local.long}"
                                        : local.erro;
                                  }
                                },
                                icon: const Icon(Icons.edit_location_alt),
                                label: const Text('Gerar Nova Localização'),
                              ),
                            ),

                            // campo LONGITUDE do ponto de interesse
                            CustomTextField(
                              controller: longitudeController,
                              label: "Longitude *",
                            ),

                            // se é rota ou ponto turistico
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: Row(
                                children: [
                                  Checkbox(
                                      value: isTouristPoint,
                                      onChanged: (value) {
                                        setState(() {
                                          isTouristPoint = value!;
                                        });
                                      }),
                                  const Text("É Ponto Turistico.")
                                ],
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Botão para cadastrar
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 16),
                              child: ElevatedButton(
                                onPressed: () {
                                  _submitUpdateForm();
                                  // _atualizarPoi();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 0, 63, 6),
                                  elevation: 10,
                                  minimumSize: const Size.fromHeight(50),
                                ),
                                child: const ScreenTextButtonStyle(
                                    text: "Salvar Alterações"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}