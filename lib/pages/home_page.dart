import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hokmabadi/controllers/auth_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Image.asset("assets/images/welcome-logo.png", width: 85),
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
        child: SafeArea(
          child: Column(
            children: [
              Image.asset("assets/images/welcome.png"),
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 45,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to Dr. H. & Co.",
                      style: Theme.of(context).textTheme.headline5,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Search for a patient below to continue",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    Stack(
                      children: [
                        const IgnorePointer(
                          ignoring: true,
                          child: Hero(
                            tag: "search",
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Search a patient",
                                suffixIcon: Icon(Icons.search, size: 20),
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: InkWell(
                              onTap: () => _searchPatient(context),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _searchPatient(BuildContext context) async {
    Modular.to.pushNamed("/patient-search");
  }

  void _signOut() async {
    await Modular.get<AuthController>().signOut();
    Modular.to.navigate("/login");
  }
}
