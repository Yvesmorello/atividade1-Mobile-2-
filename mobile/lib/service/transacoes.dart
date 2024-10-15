import 'abstract_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; 

class TransacoesApi extends AbstractApi {

  TransacoesApi() : super('transacoes');

  Future<void> addTransacao(Map<String, dynamic> transacao) async {
    var response = await http.post(
      Uri.parse('$urlLocalhost/$recurso'),  
      body: jsonEncode(transacao), 
    );
    if (response.statusCode == 201) {
      print("Transação adicionada com sucesso");
    } else {
      throw Exception("Erro ao adicionar transação");
    }
  }

  Future<void> updateTransacao(String id, Map<String, dynamic> transacao) async {
    var response = await http.put(
      Uri.parse('$urlLocalhost/$recurso/$id'),  
      body: jsonEncode(transacao), 
    );
    if (response.statusCode == 200) {
      print("Transação atualizada com sucesso");
    } else {
      throw Exception("Erro ao atualizar transação");
    }
  }

  Future<void> deleteTransacao(String id) async {
    var response = await http.delete(
      Uri.parse('$urlLocalhost/$recurso/$id'),  
    );
    if (response.statusCode == 200) {
      print("Transação excluída com sucesso");
    } else {
      throw Exception("Erro ao excluir transação");
    }
  }
}

