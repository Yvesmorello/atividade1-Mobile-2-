import 'abstract_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; 

class TransacoesApi extends AbstractApi {

  TransacoesApi() : super('transacoes');

  Future<void> addTransacao(Map<String, dynamic> transacao) async {
    await add(transacao);
  }

  Future<void> updateTransacao(String id, Map<String, dynamic> transacao) async {
    await update(id, transacao);
  }

  Future<void> deleteTransacao(String id) async {
    await delete(id);
  }
}

