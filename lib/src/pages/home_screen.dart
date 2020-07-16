import 'package:flutter/material.dart';
import 'package:interacaomedicamentosa/src/pages/interacao_screen.dart';
import 'package:interacaomedicamentosa/src/repository/mysql.dart';
import 'package:interacaomedicamentosa/src/widgets/search.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool _visible = true;

  List<dynamic> listaSelecionados = List<dynamic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 115, 128),
      appBar: AppBar(
        title: Text('Interação Medicamentosa'),
        backgroundColor: Color.fromARGB(255, 3, 87, 92),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            tooltip: 'Pesquisar',
            icon: const Icon(Icons.list),
            onPressed: (){

            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter, // 10% of the width, so there are ten blinds.
                colors: [
                  const Color.fromARGB(255, 3, 87, 92),
                  const Color.fromARGB(255, 0, 115, 128)
                ], // whitish to gray
                tileMode: TileMode.repeated, // repeats the gradient over the canvas
              ),
            ),
          ),
          Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 20, bottom: _visible ? 85 : 20),
                child: Search(listaSelecionados: listaSelecionados, comparar: _visible,),
              )
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: _visible,
        child: FloatingActionButton.extended(
          onPressed: () async {

            await Mysql.instance.get(
                path: "/interacoes/?principios_ativos="+listaSelecionados[0]["id"].toString()+"&principios_ativos="+listaSelecionados[1]["id"].toString(),
                method: "GET"
            ).then((interacao){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InteracaoScreen(interacao.data["results"]))
              );
            });
          },
          icon: const Icon(Icons.compare),
          label: Text('Comparar Medicamentos'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
