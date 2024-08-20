import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'blocs/blocs.dart';
import 'pages/home_page.dart';
import 'repositories/open_library_repository.dart';
import 'services/open_library_api_services.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => OpenLibraryRepository(
        openLibraryApiServices: OpenLibraryApiServices(
          httpClient: http.Client(),
        ),
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<OpenLibraryBloc>(
            create: (context) => OpenLibraryBloc(
              openLibraryRepository: context.read<OpenLibraryRepository>(),
            ),
          ),
          BlocProvider<SearchValuesBloc>(
            create: (context) => SearchValuesBloc(newSearchValues: {}),
          ),
          BlocProvider<PageBloc>(
            create: (context) => PageBloc(),
          ),
        ],
        child: const MaterialApp(
          title: 'Open Library App',
          debugShowCheckedModeBanner: false,
          home: HomePage(),
        ),
      ),
    );
  }
}
