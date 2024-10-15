import 'package:flutter/material.dart';
import 'package:mobile/service/transacoes_api.dart';

class AdicionarTransacaoScreen extends StatefulWidget {
  final Map<String, dynamic>? transacao; 

  AdicionarTransacaoScreen({Key? key, this.transacao}) : super(key: key);

  @override
  _AdicionarTransacaoScreenState createState() => _AdicionarTransacaoScreenState();
}

class _AdicionarTransacaoScreenState extends State<AdicionarTransacaoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _valorController = TextEditingController();
  
  final TransacoesApi api = TransacoesApi(); 

  @override
  void initState() {
    super.initState();
    if (widget.transacao != null) {
      _nomeController.text = widget.transacao!['nome'];
      _valorController.text = widget.transacao!['valor'].toString();
    }
  }

void _adicionarTransacao() async {
  if (_formKey.currentState!.validate()) {
    String nome = _nomeController.text;
    double valor = double.parse(_valorController.text);

    Map<String, dynamic> novaTransacao = {
      'nome': nome,
      'valor': valor,
    };

    try {
      if (widget.transacao == null) {
        await api.addTransacao(novaTransacao);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transação adicionada com sucesso')),
        );
      } else {
        String id = widget.transacao!['id']; 
        await api.updateTransacao(id, novaTransacao);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transação atualizada com sucesso')),
        );
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao adicionar transação: $e')),
      );
    }
  }
}



  @override
  void dispose() {
    _nomeController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.transacao == null ? 'Adicionar Transação' : 'Editar Transação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _valorController,
                decoration: InputDecoration(labelText: 'Valor'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um valor';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor, insira um número válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _adicionarTransacao,
                child: Text(widget.transacao == null ? 'Adicionar Transação' : 'Salvar Transação'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
