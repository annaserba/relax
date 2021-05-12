import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:relax/blocs/result_state.dart';
import 'package:relax/data/repository.dart';
import 'package:relax/model/category.dart';

class CategoryBloc extends Bloc<CategoryEvent, Result> {
  final DataRepository repository;

  CategoryBloc({required this.repository}) : super(Empty());



  @override
  Stream<Result<List<Category>>> mapEventToState(CategoryEvent event) async* {
    if (event is FetchCategories) {
      yield* _mapFetchCategoriesToState(event);
    }
  }

  Stream<Result<List<Category>>> _mapFetchCategoriesToState(
      FetchCategories event) async* {
    yield Loading();
    try {
      yield Success(await repository.loadCategories());
    } on Error catch (error) {
      log(error.toString());
      yield Error(error);
    }
  }
}

// Events
abstract class CategoryEvent extends Equatable {
  const CategoryEvent();
}

class FetchCategories extends CategoryEvent {
  const FetchCategories();

  @override
  List<Object> get props => [];
}
