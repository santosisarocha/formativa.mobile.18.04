import 'package:flutter_application_1/tela2.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home:TelaLogin() ,
  ));
}


class TelaLogin extends StatelessWidget {
TelaLogin({super.key});
 TextEditingController _user = TextEditingController();
 TextEditingController _passw = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Formativa"),
      ),
      body: Column(
        
        children: [
          TextFormField(
            keyboardType: TextInputType.name,
            decoration: InputDecoration(labelText: "Digite seu nome"),
            controller: _user,
          ),
          TextField(
           keyboardType: TextInputType.number,
           decoration: InputDecoration(labelText: "Digite sua senha"),
           obscureText: true,
           obscuringCharacter: '*',
           controller: _passw,

          ),
          ElevatedButton(onPressed: (){
            if(_user.text == "isa" && _passw.text=="1234"){
              print('Login correto');
              Navigator.push(context,MaterialPageRoute(builder: (context) => MyApp(),));
            }
            
            else{
              print("Login incorreto");
             
            }
            
          },

          
          
           child: Text("Entrar")),
        ],
      ),
    );
  }
}