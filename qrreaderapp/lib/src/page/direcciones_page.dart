import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;

class DireccionesPage extends StatelessWidget {

  final scansBloc = ScansBloc();

  @override
  Widget build(BuildContext context) {

    scansBloc.obtenerScans();

    return StreamBuilder<List<ScanModel>>(
      stream: scansBloc.scansStreamHttp,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final scans = snapshot.data;
        if (scans.length == 0) {
          return Center(
            child: Text('No hay registros'),
          );
        }
        /**
         * [UniqueKey] permite asignarle una key unica
         * a cada elemento, y de esa manera sepa que elemento
         * es el que se esta eliminando
         */
        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (context, index) =>Dismissible(
            key: UniqueKey(),
            background: Container(color: Colors.red),
            onDismissed: (direccion)=>scansBloc.borrarScan(scans[index].id),
            child: ListTile(
              leading: Icon(Icons.cloud_queue, color: Theme.of(context).primaryColor,),
              title: Text(scans[index].valor),
              subtitle: Text(scans[index].id.toString()),
              trailing: Icon(Icons.keyboard_arrow_right, color:Colors.green,),
              onTap: () => utils.abrirScan(context,scans[index]),
            ),
          )
         );
      },
    );
  }
  
}