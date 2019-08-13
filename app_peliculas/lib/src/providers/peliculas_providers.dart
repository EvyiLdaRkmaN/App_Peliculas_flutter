import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:app_peliculas/src/models/pelicula_model.dart';

class PeliculasProviders{

  String _apikey   = '64a3f136d4a2851193570f031eb9d186';
  String _url      = 'api.themoviedb.org';
  String _language = 'es-MX';

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);

    final peliculas = Peliculas.fromJsonList(decodeData['results']);

    // print(peliculas.items[1].title);

    return peliculas.items;
  }


  Future<List<Pelicula>> getEnCines() async {

    final url = Uri.https(_url, '3/movie/now_playing',{
      'api_key' : _apikey,
      'language': _language
    });
    
    return await _procesarRespuesta(url);
  }


  Future <List<Pelicula>> getPopulares() async {
    final url = Uri.https(_url, '3/movie/popular',{
      'api_key' : _apikey,
      'language': _language
    });
    
    return await _procesarRespuesta(url);
  }
}