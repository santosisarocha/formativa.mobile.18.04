import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InputScreen(),
    );
  }
}

class Produto {
  final String id;
  final String nome;
  final String valor;

  Produto({required this.id, required this.nome, required this.valor});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'valor': valor,
    };
  }
}

class ApiService {
  static const String apiUrl = "http://10.109.83.4:3000/produtos";

  static Future<void> postData(List<Produto> produtos) async {
    try {
      final List<Map<String, dynamic>> produtosJson = produtos.map((produto) => produto.toJson()).toList();

      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(produtosJson),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        print('Dados enviados com sucesso');
        print(produtosJson);
      } else {
        print('Falha ao enviar os dados. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao enviar os dados: $e');
    }
  }

  static Future<List<Produto>> fetchData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> produtosJson = jsonDecode(response.body)['produtos'];
        List<Produto> produtos = produtosJson.map((produto) {
          return Produto(
            id: produto['id'].toString(),
            nome: produto['nome'].toString(),
            valor: produto['valor'].toString(),
          );
        }).toList();
        return produtos;
      } else {
        print('Falha ao carregar os dados. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Erro ao carregar os dados: $e');
      return [];
    }
  }
}

class InputScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  InputScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inserir Dados'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Digite os dados (formato: id,nome,valor)'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String input = _controller.text;
                List<String> lines = input.split('\n');
                List<Produto> produtos = [];
                lines.forEach((line) {
                  List<String> parts = line.split(',');
                  if (parts.length == 3) {
                    produtos.add(Produto(id: parts[0], nome: parts[1], valor: parts[2]));
                  }
                });
                await ApiService.postData(produtos);
                if (produtos.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DisplayScreen(produtos: produtos)),
                  );
                } else {
                  // Tratar caso a lista de produtos esteja vazia
                }
              },
              child: Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}

class DisplayScreen extends StatelessWidget {
  final List<Produto> produtos;

  DisplayScreen({required this.produtos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exibir Dados'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Dados da API:',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: produtos.length,
                itemBuilder: (context, index) {
                  Produto produto = produtos[index];
                  return ListTile(
                    title: Text(produto.nome),
                    subtitle: Text("ID: ${produto.id}, Valor: ${produto.valor}"),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
