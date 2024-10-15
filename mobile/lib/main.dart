import 'package:flutter/material.dart';
import 'package:mobile/service/transacoes.dart';
import 'screen/AdicionarTransacaoScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicação Bancária',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const MyHomePage(title: 'Aplicação Bancária'),
        '/adicionar': (context) => AdicionarTransacaoScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> transacoes = [];
  final TransacoesApi api = TransacoesApi();

  @override
  void initState() {
    super.initState();
    _carregarTransacoes();
  }

  void _carregarTransacoes() async {
    try {
      List<Map<String, dynamic>> transacoesCarregadas = List<Map<String, dynamic>>.from(await api.getAll());
      setState(() {
        transacoes = transacoesCarregadas;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar transações: $e')),
      );
    }
  }

void _editarTransacao(Map<String, dynamic> transacao) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AdicionarTransacaoScreen(transacao: transacao), 
    ),
  ).then((_) {
    _carregarTransacoes(); 
  });
}


 void _excluirTransacao(String id) async {
  try {
    await api.deleteTransacao(id); 
    _carregarTransacoes(); 
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Transação excluída com sucesso')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao excluir transação: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: transacoes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(transacoes[index]['nome']),
            subtitle: Text('Valor: ${transacoes[index]['valor']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _editarTransacao(transacoes[index]),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _excluirTransacao(transacoes[index]['id']),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/adicionar').then((_) {
            _carregarTransacoes();
          });
        },
        tooltip: 'Adicionar Transação',
        child: const Icon(Icons.add),
      ),
    );
  }
}
