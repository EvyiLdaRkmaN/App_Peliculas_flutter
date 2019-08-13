import 'package:app_peliculas/src/models/pelicula_model.dart';
import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';

class CardSwiper extends StatelessWidget {
  
  final List<Pelicula> peliculas;
  
  CardSwiper({@required this.peliculas});

  @override
  Widget build(BuildContext context) {

    /**
     * [_screensSize] Nos permite camabiar las dimenciones
     * de la tarjetas dependiendo del tamaño de pantalla del 
     * dispositivo
     */
    final _screensSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 5.0),
      
      child: Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: _screensSize.width * 0.7,
        itemHeight: _screensSize.height * 0.5,
        itemBuilder: (BuildContext context, int index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child:FadeInImage(
              image: NetworkImage(peliculas[index].getPosterImg()),
              placeholder: AssetImage('assets/img/loading.gif'),
              fit: BoxFit.cover,
            ),
          );
        },
        itemCount: peliculas.length,
      ),
    );
  }
}
