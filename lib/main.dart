import 'services/api_service.dart';
//import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(
          create: (_) => ApiService(baseUrl: 'https://ucf-club-and-event-manager-1c53fb944ab8.herokuapp.com/api/v1/users'), // Replace with your backend URL
        ),
      ],
      child: MaterialApp(
        title: 'Flutter MERN App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const RegisterPage(),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _userName = '';
  String _email = '';
  String _password = '';
  String _firstName = '';
  String _lastName = '';

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Username'),
                onChanged: (value) {
                  setState(() {
                    _userName = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'First Name'),
                onChanged: (value) {
                  setState(() {
                    _firstName = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Last Name'),
                onChanged: (value) {
                  setState(() {
                    _lastName = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final response = await apiService.registerUser({
                      'userName': _userName,
                      'email': _email,
                      'password': _password,
                      'firstName': _firstName,
                      'lastName': _lastName,
                    });

                    //Print the url it is trying to access
                    print(response.request!.url);

                    //print status code and response body
                    print(response.statusCode);
                    print(response.body);
                  }
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}