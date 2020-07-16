import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:interacaomedicamentosa/src/repository/mysql.dart';

class Search extends StatefulWidget {

  List<dynamic> listaSelecionados;
  bool comparar;

  Search({Key key, @required this.listaSelecionados, @required this.comparar}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  final _searchController = TextEditingController();

  List<dynamic> recentes = List<dynamic>();
  List<dynamic> medicamentos = List<dynamic>();
  List<dynamic> listaSugestoes = List<dynamic>();
//  List<dynamic> listaSelecionados = List<dynamic>();

  @override
  Widget build(BuildContext context) {

    listaSugestoes = (medicamentos.isEmpty || _searchController.text.isEmpty)
        ? recentes.reversed.toList()
        : medicamentos;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment
              .bottomCenter, // 10% of the width, so there are ten blinds.
          colors: [
            const Color.fromARGB(255, 10, 50, 71),
            const Color.fromARGB(255, 7, 35, 50)
          ], // whitish to gray
          tileMode: TileMode.repeated, // repeats the gradient over the canvas
        ),
      ),
      width: 300,
      child: Column(
        children: <Widget>[
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Insira o Princípio Ativo",
              contentPadding: const EdgeInsets.only(top: 20, bottom: 20),
              hintStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
              ),
              labelStyle: TextStyle(color: Color.fromARGB(255, 0, 225, 255)),
              prefixIcon: Icon(Icons.search),
              suffixIcon: Visibility(
                visible: _searchController.text.length > 0,
                child: IconButton(
                    padding: EdgeInsets.all(0),
                    icon: Icon(
                      Icons.close,
                      color: Colors.teal,
                    ),
                    onPressed: (){
                      setState(() {
                        _searchController.text = "";
                      });
                    }
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0)),
              ),
            ),
            style: TextStyle(color: Color.fromARGB(255, 0, 225, 255), fontSize: 18),
            cursorColor: Colors.grey,
            onChanged: (text) {
              filterList(_searchController.text).then((docs) {
                if (docs != null) {
                  setState(() {
                    medicamentos = docs;
                  });
                }
              });
            },
          ),
          Expanded(
            child: Container(
              //color: Colors.cyan,
              child: ListView.builder(
                itemCount: listaSugestoes.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return  Material(
                    child: new InkWell(
                      child: new ListTile(
                        onTap: (){
                          if(widget.listaSelecionados.length < 2){
                            setState(() {
                              if(!widget.listaSelecionados.contains(listaSugestoes[index])){

                                widget.listaSelecionados.add(listaSugestoes[index]);

                                if(recentes.contains(listaSugestoes[index])){
                                  recentes.remove(listaSugestoes[index]);
                                }

                                recentes.add(listaSugestoes[index]);

                                _searchController.text = "";

                                setState(() {
                                  widget.comparar = (widget.listaSelecionados.length == 2);
                                  //print(widget.comparar);
                                });
                              }
                            });
                          }
                        },
                        leading: _searchController.text.isNotEmpty
                            ? FaIcon(FontAwesomeIcons.capsules, color: Color.fromARGB(255, 0, 225, 255),)
                            : Icon(Icons.history, color: Color.fromARGB(255, 0, 225, 255),),
                        title: parteStringNegrito(
                            listaSugestoes[index]["nome"], _searchController.text.toLowerCase()),
                      )
                    ),
                    color: Colors.transparent,
                  );
                },
              ),
            ),
          ),
          Divider(
            color: Colors.teal,
            height: 1,
          ),
          Container(
            height: 110,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.listaSelecionados.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return  ListTile(
                  onTap: (){},
                  leading: FaIcon(FontAwesomeIcons.capsules, color: Color.fromARGB(255, 0, 225, 255),),
                  trailing: IconButton(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.all(0),
                    icon: Icon(Icons.close, color: Colors.red[800]),
                    onPressed: (){
                      setState(() {
                        widget.listaSelecionados.remove(widget.listaSelecionados[index]);
                      });
                    },
                  ),
                  title: parteStringNegrito(
                      widget.listaSelecionados[index]["nome"], widget.listaSelecionados[index]["nome"]),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget parteStringNegrito(String textoOriginal, String textoNegrito) {

    int inicioIndex = (textoOriginal.toLowerCase().indexOf(textoNegrito) != -1)
        ? textoOriginal.toLowerCase().indexOf(textoNegrito)
        : 0;

    int fimIndex = (textoOriginal.toLowerCase().indexOf(textoNegrito) != -1)
        ? textoNegrito.length + inicioIndex
        : 0;

    if (fimIndex > textoOriginal.length) fimIndex = textoOriginal.length;

    return RichText(
      text: TextSpan(
        text: textoOriginal.substring(0, inicioIndex),
        style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w400, fontSize: 18),
        children: [
          TextSpan(
            text: textoOriginal.substring(inicioIndex, fimIndex),
            style: TextStyle(color: Color.fromARGB(255, 0, 225, 255), fontWeight: FontWeight.bold, fontSize: 18),
            children: [
              TextSpan(
                  text: textoOriginal.substring(fimIndex, textoOriginal.length),
                  style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w400, fontSize: 18))
            ],
          ),
        ],
      ),
    );
  }

  Future<List<dynamic>> filterList(String filter) async {
    List<dynamic> results;

    if (filter.isEmpty) return results;

    if(widget.listaSelecionados.length == 1){
      await Mysql.instance.get(
          path: '/principios-ativos/'+widget.listaSelecionados[0]["id"].toString()+'/interacoes/',
          method: "GET"
      ).then((response) {

        List<dynamic> ListaInteracoesOriginal;
        List<dynamic> ListaInteracoes = List<dynamic>();

        List<dynamic> temp;

        ListaInteracoesOriginal = response.data["results"];

        ListaInteracoesOriginal.forEach((item){
          temp = item["principios_ativos"];
          temp = temp.where((item2) => item2["nome"] != widget.listaSelecionados[0]["nome"]).toList();
          ListaInteracoes.add(temp[0]);
        });

        results = ListaInteracoes.where((e) => e["nome"].toLowerCase().contains(filter)).toList();
      });
    }else{

      await Mysql.instance.get(
          path: '/principios-ativos/?search=' + filter,
          method: "GET"
      ).then((response) {
        results = response.data["results"];
      });
    }

    return results;
  }
}
