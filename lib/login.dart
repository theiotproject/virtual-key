import 'package:flutter/material.dart';
import 'package:virtual_key/services/remote_service.dart';
import 'package:virtual_key/globals.dart';
import 'package:http/http.dart' as http;
import 'package:virtual_key/widgets/custom_appbar.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  bool isEmailValid = true;
  bool isPasswordHidden = true;

  String errorMsg = '';

  @override
  void initState() {
    super.initState();

    emailController.addListener(() => setState(() {
          isEmailValid = emailRegExp.hasMatch(emailController.text) ||
              emailController.text.isEmpty;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Log in', true),
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
                  isLogged = true;
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/user_hub', (_) => false);
                } else {
                  setState(() {
                    errorMsg = 'User does not exist';
                  });
                }
              },
              child: const Text('Submit'),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                errorMsg,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                onPressed: (() =>
                    Navigator.pushNamed(context, '/emergency_open')),
                icon: const Icon(
                  Icons.lock_reset,
                  size: 32,
                  color: Colors.grey,
                ),
              ),
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
          errorText: isEmailValid ? null : 'Invalid email adress',
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
          suffixIcon: IconButton(
            onPressed: () =>
                setState(() => isPasswordHidden = !isPasswordHidden),
            icon: isPasswordHidden
                ? const Icon(Icons.visibility_off)
                : const Icon(Icons.visibility),
          ),
          border: const OutlineInputBorder(),
        ),
        obscureText: isPasswordHidden,
      );
}
