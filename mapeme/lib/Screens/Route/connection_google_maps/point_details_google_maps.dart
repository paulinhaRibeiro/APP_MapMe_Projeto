import 'package:flutter/material.dart';

import '../../../Models/point_interest.dart';
import '../../Widgets/listagem_widgets.dart/imagem_point_widget.dart';
import '../../Widgets/listagem_widgets.dart/nome_point_widget.dart';
import '../iniciar_Rota/model_point_lat_long_route.dart';

class PointDetailsGoogleMaps extends StatelessWidget {
  final PointOfInterestLatLong? pLatLong;
  final PointInterest? point;
  const PointDetailsGoogleMaps({super.key, this.pLatLong, this.point});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: _buildContent(),
      ),
    );
  }

  List<Widget> _buildContent() {
    if (pLatLong != null) {
      return [
        pLatLong!.img1 != ""
            ? ImagemPoint(nomeImagem: pLatLong!.img1)
            : ImagemPoint(nomeImagem: pLatLong!.img2),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
          child: NomePoint(
            nomePoint: pLatLong!.name,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
          child: Text(
            pLatLong!.description,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: Row(
            children: [
              const Expanded(
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Localização',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              const Expanded(
                child: Divider(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
          child: Text(
            'O ponto "${pLatLong!.name}" com o tipo "${pLatLong!.typePointInterest.toLowerCase()}" está situado a uma latitude de "${pLatLong!.latitude}" e uma longitude de "${pLatLong!.longitude}".',
          ),
        ),
      ];
    } else {
      return [
        point!.img1 != ""
            ? ImagemPoint(nomeImagem: point!.img1)
            : ImagemPoint(nomeImagem: point!.img2),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
          child: NomePoint(
            nomePoint: point!.name,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
          child: Text(
            point!.description,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: Row(
            children: [
              const Expanded(
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Localização',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              const Expanded(
                child: Divider(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
          child: Text(
            'O ponto "${point!.name}" com o tipo "${point!.typePointInterest.toLowerCase()}" está situado a uma latitude de "${point!.latitude}" e uma longitude de "${point!.longitude}".',
          ),
        ),
      ];
    } 
  }
}
