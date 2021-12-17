import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hokmabadi/utils/snackbar_messenger.dart';

class PatientSearchPage extends StatefulWidget {
  const PatientSearchPage({Key? key}) : super(key: key);

  @override
  _PatientSearchState createState() => _PatientSearchState();
}

class _PatientSearchState extends State<PatientSearchPage> {
  final _formKey = GlobalKey<FormState>();

  String? _firstName;
  String? _lastName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Search for patient"),
        ),
        backgroundColor: Colors.white,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.fromLTRB(22, 0, 22, 15),
          child: ElevatedButton(
            onPressed: _search,
            child: const Text("Search"),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 71),
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  const Text(
                    "Please enter at least one of the first name or the last name of a patient to search.",
                  ),
                  const SizedBox(height: 35),
                  TextFormField(
                    decoration: const InputDecoration(hintText: "First name"),
                    onSaved: (value) {
                      _firstName = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(hintText: "Last name"),
                    onSaved: (value) {
                      _lastName = value;
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _search() {
    FocusScope.of(context).unfocus();
    _formKey.currentState?.save();

    if ((_firstName?.isEmpty ?? true) && (_lastName?.isEmpty ?? true)) {
      SnackBarMessenger.showDanger(context,
          "At least one of first name or last name is required to continue.");
      return;
    }

    Modular.to.pushNamed(
        "/patient-results?firstName=$_firstName&lastName=$_lastName");
  }
}
