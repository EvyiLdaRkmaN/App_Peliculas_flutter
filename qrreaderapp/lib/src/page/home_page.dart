import 'dart:io';

import 'package:flutter/material.dart';

import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';

import 'package:qrreaderapp/src/page/direcciones_page.dart';
import 'package:qrreaderapp/src/page/mapas_page.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansBloc = ScansBloc();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scansBloc.borrarScanTodos,
          ),
        ],
      ),
      body:_callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigatorBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: ()=>_scanQR(context),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  _scanQR(BuildContext context)async{

    //geo:40.700291257425135,-73.94139662226564 

    // String futureString = 'https://google.com.mx';
    String futureString;
    
    try{
      futureString = await QRCodeReader().scan();
    } catch(e){
      futureString = e.toString();
    }
    print('futureString = $futureString');
    if (futureString != null) {
      print('Tenemos información');
    }

    if(futureString != null){
      final scan = ScanModel(valor: futureString );
      scansBloc.agregarScan(scan);

      if (Platform.isIOS) {
        Future.delayed(Duration(milliseconds: 750),(){utils.abrirScan(context,scan);});
      }else{
        utils.abrirScan(context ,scan);
      }

    }


  }

  Widget _callPage(int paginaActual){
    switch (paginaActual) {
      case 0: return MapasPage();
        break;
      case 1: return DireccionesPage();
      default:
        return MapasPage();
    }
  }

  Widget _crearBottomNavigatorBar(){
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (i){
        setState(() {
         currentIndex = i; 
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Direcciones')
        ),
      ],
    );
  }
}
