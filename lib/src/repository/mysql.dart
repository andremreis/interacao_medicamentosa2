import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// Padrão Singletrom
class Mysql{

  Uri url = Uri.parse('https://api.interage.intmed.com.br/v1');
  String chave = "933b55278d525b2820de8657df814647f86d89d7";

  static final Mysql instance = Mysql.internal();

  factory Mysql() => instance;

  Mysql.internal();

  Future<Response> get({@required String path, @required String method}) async{

    Response response = await Dio().request(
      this.url.toString() + path,
      options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Token " + chave },
          method: method.toUpperCase()
      ),
    );

    return response;
  }


}