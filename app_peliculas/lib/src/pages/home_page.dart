import 'package:app_peliculas/src/providers/peliculas_providers.dart';
import 'package:app_peliculas/src/widgets/movie_horizontal.dart';
import 'package:flutter/material.dart';

import 'package:app_peliculas/src/widgets/card_swiper_widget.dart';



////[SafeArea] permite que se respete el espacio que se tiene
/// en los dispositivos moviles para que todo se establesca despues 
/// de la barra de estado del movil(donde aparece información de bateria
/// entre otras cosas)

class HomePage extends StatelessWidget {

  final peliculasProviders = PeliculasProviders();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Peliculas en cines'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){},
          ),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swiperTarjetas(),
            _footer(context),
          ],),
      ),
    );
  }

  Widget _swiperTarjetas(){

    return FutureBuilder(
      future: peliculasProviders.getEnCines(),
      // initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(
            peliculas: snapshot.data
          );
        }else{
          return Container(
            height: 400.0,
            child: Center(
              child: CircularProgressIndicator())
          );
        }
      },
    );
  }


  Widget _footer(BuildContext context){
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text('populares',
              style: Theme.of(context).textTheme.subhead,)
          ),
          SizedBox(height: 5.0),
          FutureBuilder(
            future: peliculasProviders.getPopulares(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(peliculas: snapshot.data,);
              }else{
                return Container(
                  child: Center(
                    child: CircularProgressIndicator())
                );
              }
            },
          ),
        ],
      ),
    );
  }

}