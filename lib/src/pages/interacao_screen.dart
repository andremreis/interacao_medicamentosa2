import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class InteracaoScreen extends StatelessWidget {
  
  List<dynamic> _interacao;
  Color _colorGravidade;
  Color _colorIcon;

  InteracaoScreen(this._interacao);

  @override
  Widget build(BuildContext context) {

    if(_interacao.length > 0){
      //_interacao[0]["gravidade"]
      switch(_interacao[0]["gravidade"]){
        case 'Grave':
          _colorGravidade = Colors.red.shade800;
          _colorIcon = Colors.white70;
          break;
        case 'Nada esperado':
          _colorGravidade = Colors.blueGrey;
          _colorIcon = Colors.white70;
          break;
        case 'Leve':
          _colorGravidade = Colors.orangeAccent;
          _colorIcon = Colors.white70;
          break;
        case 'Moderada':
          _colorGravidade = Colors.deepOrangeAccent;
          _colorIcon = Colors.white70;
          break;
        case 'Gravidade desconhecida':
          _colorGravidade = Colors.blueGrey;
          _colorIcon = Colors.white70;
          break;
        default:
          _colorGravidade = _colorGravidade;
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _colorGravidade,
        title: Text("Interação"),
        centerTitle: true,
      ),
      body: _interacao.length > 0
          ? ListView(
              padding: EdgeInsets.only(right: 20, bottom: 20, left: 20),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: Card(
                    elevation: 15,
                    color: _colorGravidade,
                    child: Container(
                      height: 150,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 10, left: 10),
                            child: Text(
                              "Gravidade",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
                          ),
                          Center(
                            child: Text(
                              _interacao[0]["gravidade"],
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                infoSimples(
                    Icons.bubble_chart,
                    _colorGravidade,
                    _colorGravidade,
                    "Evidência",
                    _interacao[0]["evidencia"]),
                infoSimples(
                    Icons.thumbs_up_down,
                    _colorGravidade,
                    _colorGravidade,
                    "Ação",
                    _interacao[0]["acao"]),
                infoSimples(
                    Icons.info,
                    _colorGravidade,
                    _colorGravidade,
                    "Explicação",
                    _interacao[0]["explicacao"]),
              ],
            )
          : Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.assignment_late,
                  size: 120,
                  color: Theme.of(context).primaryColor,
                ),
                Text(
                  "Nenhuma Interação Encontrada \nPara Estes Medicamentos!",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                  textAlign: TextAlign.center,
                ),
              ],
            )),
    );
  }

  Widget infoSimples(IconData icon, Color iconBackgroundColor, Color iconColor,
      String title, String text) {
    return Card(
      child: ListTile(
        leading: SizedBox(
          height: 60,
          width: 60,
          child: CircleAvatar(
            backgroundColor: iconBackgroundColor,
            child: Icon(
              icon,
              size: 35,
              color: _colorIcon,
            ),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 20, color: iconColor, fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            text,
            style: TextStyle(fontSize: 15),
          ),
        ),
        isThreeLine: true,
      ),
    );
  }
}
