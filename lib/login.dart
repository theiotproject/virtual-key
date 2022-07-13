import 'package:flutter/material.dart';
import 'package:virtual_key/services/remote_service.dart';
import 'package:virtual_key/globals.dart';
import 'package:http/http.dart' as http;
import 'package:virtual_key/models/user.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;

  User? user;

  @override
  void initState() {
    super.initState();

    emailController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(32),
          children: [
            buildEmail(),
            const SizedBox(height: 24),
            buildPassword(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                http.Response response = await RemoteService().login(
                    emailController.text, passwordController.text, "phonename");

                token = response.body;

                user = await RemoteService().getUser();
                if (user != null) {
                  print(user!.email);
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEmail() => TextField(
        controller: emailController,
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'name@example.com',
          prefixIcon: const Icon(Icons.mail),
          suffixIcon: emailController.text.isEmpty
              ? Container(width: 0)
              : IconButton(
                  onPressed: () => emailController.clear(),
                  icon: const Icon(Icons.close),
                ),
          border: const OutlineInputBorder(),
        ),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
      );

  Widget buildPassword() => TextField(
        controller: passwordController,
        decoration: InputDecoration(
          labelText: 'Password',
          hintText: 'Your password',
          errorText: 'Password is invalid',
          suffixIcon: IconButton(
            onPressed: () =>
                setState(() => isPasswordVisible = !isPasswordVisible),
            icon: isPasswordVisible
                ? const Icon(Icons.visibility_off)
                : const Icon(Icons.visibility),
          ),
          border: const OutlineInputBorder(),
        ),
        obscureText: isPasswordVisible,
      );
}
