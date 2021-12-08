import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hokmabadi/config/app_config.dart';
import 'package:hokmabadi/controllers/auth_controller.dart';
import 'package:hokmabadi/utils/snackbar_messenger.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _showPassword = ValueNotifier(false);

  String? _username;
  String? _password;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Sign in"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
          child: SafeArea(
            child: Column(
              children: [
                Image.asset("assets/images/welcome.png"),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 30,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Type your credentials below to continue.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 25),
                        TextFormField(
                          enabled: !_isLoading,
                          initialValue:
                              kDebugMode ? AppConfig.authUsername : null,
                          decoration: const InputDecoration(
                            hintText: "Username",
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return "This field is required.";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _username = value!;
                          },
                        ),
                        const SizedBox(height: 15),
                        ValueListenableBuilder(
                          valueListenable: _showPassword,
                          builder: (context, bool value, child) {
                            return TextFormField(
                              enabled: !_isLoading,
                              initialValue:
                                  kDebugMode ? AppConfig.authPassword : null,
                              obscureText: !value,
                              decoration: InputDecoration(
                                hintText: "Password",
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _showPassword.value = !value;
                                  },
                                  icon: Icon(
                                    !value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    size: 20,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return "This field is required.";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _password = value!;
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 35),
                        ConstrainedBox(
                          constraints: const BoxConstraints.tightFor(
                              width: double.maxFinite),
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submit,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 26,
                                    height: 26,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 3),
                                  )
                                : const Text("Continue"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      await Modular.get<AuthController>().login(_username!, _password!);
      Modular.to.navigate("/");
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      SnackBarMessenger.showDanger(context, error.toString());
    }
  }
}
