import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:hokmabadi/controllers/auth_controller.dart';
import 'package:hokmabadi/pages/home_page.dart';
import 'package:hokmabadi/pages/patient_results_page.dart';
import 'package:hokmabadi/pages/patient_search_page.dart';
import 'package:hokmabadi/pages/login_page.dart';
import 'package:hokmabadi/pages/virtual_appointment_page/index.dart';
import 'package:hokmabadi/repositories/agora_repository.dart';
import 'package:hokmabadi/repositories/appointment_repository.dart';
import 'package:hokmabadi/repositories/auth_repository.dart';
import 'package:hokmabadi/repositories/location_repository.dart';
import 'package:hokmabadi/repositories/patient_repository.dart';
import 'package:hokmabadi/repositories/token_repository.dart';
import 'package:hokmabadi/utils/http_client.dart';

import 'models/patient.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton((i) => AppHttpClient()),
        Bind.factory((i) => AuthRepository(httpClient: i(),),),
        Bind.singleton((i) => AuthController(authRepository: i(),)),
        Bind.lazySingleton((i) => PatientRepository(authController: i())),
        Bind.lazySingleton((i) => AppointmentRepository(authController: i())),
        Bind.lazySingleton((i) => LocationRepository(authController: i())),
        Bind.lazySingleton((i) => AgoraRepository(authController: i())),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          "/login",
          child: (context, args) => const LoginPage(),
          guards: [UnauthenticatedGuard()],
        ),
        ChildRoute(
          "/",
          child: (context, args) => const HomePage(),
          guards: [AuthenticatedGuard()],
        ),
        ChildRoute(
          "/patient-search",
          child: (context, args) => const PatientSearchPage(),
          guards: [AuthenticatedGuard()],
        ),
        ChildRoute(
          "/patient-results",
          child: (context, args) {
            final firstName = args.queryParams["firstName"];
            final lastName = args.queryParams["lastName"];
            return PatientResultsPage(firstName: firstName, lastName: lastName);
          },
          guards: [AuthenticatedGuard()],
        ),
        ChildRoute(
          "/virtual-appointment/:patientId",
          child: (context, args) {
            final patientId = args.params['patientId'].toString();
            final patient = args.data is Patient ? args.data : null;
            return VirtualAppointmentPage(patientId, patient: patient);
          },
          guards: [AuthenticatedGuard()],
        ),
      ];
}

class AuthenticatedGuard extends RouteGuard {
  AuthenticatedGuard() : super(redirectTo: "/login");

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    final auth = Modular.get<AuthController>();
    return auth.isLoggedIn ? true : false;
  }
}

class UnauthenticatedGuard extends RouteGuard {
  UnauthenticatedGuard() : super(redirectTo: "/");

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    final auth = Modular.get<AuthController>();
    return !auth.isLoggedIn ? true : false;
  }
}
