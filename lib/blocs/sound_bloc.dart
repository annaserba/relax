import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:relax/blocs/result_state.dart';
import 'package:relax/data/repository.dart';
import 'package:relax/model/sound.dart';

class SoundBloc extends Bloc<SoundEvent, Result> {
  final DataRepository repository;

  SoundBloc({required this.repository}) :  super(Empty());


  @override
  Stream<Result> mapEventToState(SoundEvent event) async* {
    if (event is FetchSounds) {
      yield* _mapFetchSoundsToState(event);
    } else if (event is UpdateSound) {
      yield* _mapUpdateSoundToState(event);
    }
  }

  Stream<Result<List<Sound>>> _mapFetchSoundsToState(FetchSounds event) async* {
    yield Loading();
    try {
      yield Success(await repository.loadSounds(event.categoryId));
    } on Error catch (error) {
      yield Error(error);
    }
  }

  Stream<Result<List<Sound>>> _mapUpdateSoundToState(UpdateSound event) async* {
    try {

      // stop any random sound playing
      if(repository.isPlaying && repository.isPlayingRandom()) {
        await repository.stopRandom();
      }

      await repository.updateSound(event.soundId, event.active, event.volume); //update
      _mapFetchSoundsToState(FetchSounds(categoryId: event.soundId.substring(0, 1))); // return the updated sounds
    } on Error catch (error) {
      yield Error(error);
    }
  }
}

// Events
abstract class SoundEvent extends Equatable {
  const SoundEvent();
}

class FetchSounds extends SoundEvent {
  final String categoryId;

  const FetchSounds({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}

class UpdateSound extends SoundEvent {
  final String soundId;
  final bool active;
  final double volume;

  const UpdateSound(
      {required this.soundId, required this.active, required this.volume});

  @override
  List<Object> get props => [soundId, active];
}
