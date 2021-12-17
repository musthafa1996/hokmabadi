import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hokmabadi/models/patient.dart';
import 'package:hokmabadi/repositories/patient_repository.dart';

class PatientResultsPage extends StatefulWidget {
  const PatientResultsPage({
    Key? key,
    this.firstName,
    this.lastName,
  }) : super(key: key);

  final String? firstName;
  final String? lastName;

  @override
  _PatientSearchState createState() => _PatientSearchState();
}

class _PatientSearchState extends State<PatientResultsPage> {
  final _queryController = TextEditingController();

  Future<List<Patient>?>? _patientsFuture;

  @override
  void initState() {
    _patientsFuture = widget.firstName == null || widget.lastName == null
        ? Future.value(null)
        : Modular.get<PatientRepository>().search(
            firstName: widget.firstName,
            lastName: widget.lastName,
          );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient results"),
      ),
      // backgroundColor: Theme.of(context).colorScheme.background,
      body: FutureBuilder<List<Patient>?>(
        future: _patientsFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              break;
            case ConnectionState.done:
              if (snapshot.hasError) {
                return _buildError();
              } else if (snapshot.data?.isEmpty ?? true) {
                return _buildEmpty();
              } else {
                return _buildList(snapshot.data!);
              }
          }
          return _buildLoading();
        },
      ),
    );
  }

  Widget _buildError() {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.symmetric(
          vertical: 35,
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
              const Text(
                "Soemthing went wrong while searching. Please try again.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
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
                  onPressed: _search,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.symmetric(
          vertical: 35,
          horizontal: 15,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints.tightFor(width: 280),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning_amber,
                size: 100,
              ),
              const SizedBox(height: 20),
              Text(
                "No matches found",
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              const Text(
                "No patients were found with the provided name.",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(vertical: 35),
      child: const CircularProgressIndicator(),
    );
  }

  Widget _buildList(List<Patient> patients) {
    final MediaQueryData data = MediaQuery.of(context);
    double bottomPadding = data.padding.bottom;

    if (data.padding.bottom == 0.0 && data.viewInsets.bottom != 0.0) {
      bottomPadding = data.viewPadding.bottom;
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: 10, bottom: bottomPadding + 30),
      itemBuilder: (context, index) {
        final patient = patients[index];
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 550),
            child: ListTile(
                onTap: () {
                  Modular.to.pushNamed("/virtual-appointment/${patient.id}",
                      arguments: patient);
                },
                contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                // isThreeLine: true,
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  // child: Icon(Icons.person,
                  //     color: Theme.of(context).colorScheme.background),
                  child: Text(patient.firstName[0]),
                ),
                title: Text(
                  "${patient.firstName} ${patient.lastName}",
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 3),
                    Text(
                      patient.emailAddress ?? "--",
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      patient.phones?.isEmpty ?? true
                          ? "--"
                          : patient.phones!.first.number,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                )),
          ),
        );
      },
      itemCount: patients.length,
    );
  }

  void _search() {
    FocusScope.of(context).unfocus();
    _queryController.text = _queryController.text.trim();
    if (_queryController.text.isEmpty) return;

    setState(() {
      _patientsFuture = Modular.get<PatientRepository>().search(
        firstName: widget.firstName,
        lastName: widget.lastName,
      );
    });
  }
}
