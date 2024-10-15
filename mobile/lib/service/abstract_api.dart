import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class AbstractApi {
  final String urlLocalhost = 'http://localhost:3000';
  final String recurso;

  AbstractApi(this.recurso);

  Future<List<dynamic>> getAll() async {
    var response = await http.get(Uri.parse('$urlLocalhost/$recurso'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erro ao buscar $recurso");
    }
  }

  Future<void> add(Map<String, dynamic> item) async {
    var response = await http.post(
      Uri.parse('$urlLocalhost/$recurso'),
      body: jsonEncode(item),
    );
    if (response.statusCode == 201) {
      print("Item adicionado com sucesso");
    } else {
      throw Exception("Erro ao adicionar item em $recurso");
    }
  }

  Future<void> update(String id, Map<String, dynamic> item) async {
    var response = await http.put(
      Uri.parse('$urlLocalhost/$recurso/$id'),
      body: jsonEncode(item),
    );
    if (response.statusCode == 200) {
      print("Item atualizado com sucesso");
    } else {
      throw Exception("Erro ao atualizar item em $recurso");
    }
  }

  Future<void> delete(String id) async {
    var response = await http.delete(Uri.parse('$urlLocalhost/$recurso/$id'));
    if (response.statusCode == 200) {
      print("Item excluído com sucesso");
    } else {
      throw Exception("Erro ao excluir item em $recurso");
    }
  }
}
