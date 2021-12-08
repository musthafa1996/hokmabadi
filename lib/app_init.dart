import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hokmabadi/controllers/auth_controller.dart';

class AppInit extends StatefulWidget {
  const AppInit({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  _AppInitState createState() => _AppInitState();
}

class _AppInitState extends State<AppInit> {
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await Modular.get<AuthController>().checkIfPreviouslySignedIn();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoading();
    } else if (_error != null) {
      return _buildError();
    } else {
      return widget.child;
    }
  }

  Widget _buildLoading() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsetsDirectional.all(25),
        alignment: Alignment.center,
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 200,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/images/splash-screen-logo.png"),
              const SizedBox(height: 50),
              const LinearProgressIndicator(
                color: Colors.black,
                backgroundColor: Colors.black12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.symmetric(
            vertical: 25,
            horizontal: 15,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints.tightFor(width: 280),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 100,
                ),
                const SizedBox(height: 20),
                Text(
                  "An error occurred",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  _error ?? "Something went wrong! Please try again.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 35),
                ConstrainedBox(
                  constraints:
                      const BoxConstraints.tightFor(width: double.maxFinite),
                  child: ElevatedButton(
                    child: const Text(
                      "Retry",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      init();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
