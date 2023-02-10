// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart'
// hide PhoneAuthProvider, EmailAuthProvider;
// import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quick_list/widget_tree.dart';
import 'package:dynamic_color/dynamic_color.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

Color brandColor = const Color(0XFF4166f5);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? dark) {
      ColorScheme lightColorScheme;
      ColorScheme darkColorScheme;

      if (lightDynamic != null && dark != null) {
        lightColorScheme = lightDynamic.harmonized()..copyWith();
        lightColorScheme = lightColorScheme.copyWith(secondary: brandColor);
        darkColorScheme = dark.harmonized()..copyWith();
      } else {
        lightColorScheme = ColorScheme.fromSeed(seedColor: brandColor);
        darkColorScheme = ColorScheme.fromSeed(
            seedColor: brandColor, brightness: Brightness.dark);
      }

      return MaterialApp(
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        home: const WidgetTree(),
      );
    });
  }
}

// class MyApp extends StatelessWidget {
//   MyApp({super.key});
//   // final FirebaseAuth auth = FirebaseAuth.instance;
  
//   // const providers = [EmailAuthProvider()];

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Firebase Crud', //home: form(),
//       // initialRoute:
//       //     FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/home',
//       // routes: {
//       //   '/sign-in': (context) {
//       //     return SignInScreen(
//       //       providers: [
//       //         EmailAuthProvider(),
//       //       ],
//       //       actions: [
//       //         AuthStateChangeAction<SignedIn>((context, state) {
//       //           Navigator.pushReplacementNamed(context, '/home');
//       //         }),
//       //       ],
//       //     );
//       //   },
//       //   '/home': (context) {
//       //     return Scaffold(
//       //       appBar: AppBar(
//       //         title: const Text('Sign in successful'),
//       //       ),
//       //       body: IconButton(
//       //         icon: const Icon(Icons.exit_to_app),
//       //         onPressed: () {
//       //            SignInScreen(
//       //       providers: [
//       //         EmailAuthProvider(),
//       //       ],
//       //       actions: [
//       //         AuthStateChangeAction<SignedIn>((context, state) {
//       //           Navigator.pushReplacementNamed(context, '/sign-in');
//       //         }),
//       //       ],
//       //     );
//       //         },
//       //       ),
//       //     );
//       //   }
//       //   // '/profile': (context) {
//       //   //   return ProfileScreen(
//       //   //     providers:  [EmailAuthProvider(),],
//       //   //     actions: [
//       //   //       SignedOutAction((context) {
//       //   //         Navigator.pushReplacementNamed(context, '/sign-in');
//       //   //       }),
//       //   //     ],
//       //   //   );
//       //   // },
//       // },
    
//     );
//   }
// }

// class form extends StatefulWidget {
//   const form({super.key});

//   @override
//   State<form> createState() => _formState();
// }

// class _formState extends State<form> {
//   final controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Firebase Crud'),
//         ),
//         body: Padding(
//           padding: EdgeInsets.all(20),
//           child: Column(
//             children: [
//               TextField(
//                 controller: controller,
//               ),
//               IconButton(
//                 icon: const Icon(Icons.add),
//                 onPressed: () {
//                   final name = controller.text;
//                   createUser(name: name);
//                 },
//               )
//             ],
//           ),
//         ));
//   }

//   Future createUser({required String name}) async {
//     final docUser = FirebaseFirestore.instance.collection('users').doc();
//     final json = {'name': name, 'age': 21};
//     await docUser.set(json);
//   }
// }
