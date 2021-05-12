import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:relax/blocs/blocs.dart';
import 'package:relax/blocs/playing_bloc.dart';
import "package:relax/blocs/sound_bloc.dart";
import 'package:relax/data/repository.dart';
import 'package:relax/screens/home/home_page.dart';
import 'blocs/simple_bloc_delegate.dart';

Future<void> main() async {
  SimpleBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<DataRepository>(
      create: (_) => DataRepository(),
      child: BlocProvider(
        create: (context) => CategoryBloc(
            repository: RepositoryProvider.of<DataRepository>(context)),
        child: app(),
      ),
    );
  }

  Widget app() {
    return MaterialApp(
      title: 'Relax',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF261E1E),
      ).copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
          },
        ),
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CategoryBloc(
                repository:
                    RepositoryProvider.of<DataRepository>(context)),
          ),
          BlocProvider(
            create: (context) => PlayingSoundsBloc(
                repository:
                    RepositoryProvider.of<DataRepository>(context)),
          ),
          BlocProvider(
            create: (context) => SoundBloc(
                repository:
                RepositoryProvider.of<DataRepository>(context)),
          ),
        ],
        child: HomePage(),
      ),
    );
  }
}
