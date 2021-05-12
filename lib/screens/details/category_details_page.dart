import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:relax/blocs/sound_bloc.dart';
import 'package:relax/data/repository.dart';
import 'package:relax/model/category.dart';
import 'package:relax/screens/details/details_view.dart';

class CategoryDetailsPage extends StatelessWidget {
  final Category category;

  CategoryDetailsPage({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SoundBloc(
          repository: RepositoryProvider.of<DataRepository>(context)),
      child: DetailsView(category: category),
    );
  }

}
