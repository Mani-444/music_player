import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_app/blocs/player/audio_player_event.dart';
import 'package:music_player_app/blocs/player/audio_player_state.dart';
import 'package:music_player_app/models/song_info_model.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  final _player = AudioPlayer();
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<ProcessingState>? _completionSubscription;
  final List<SongInfoModel> songs;
  int currentIndex = 0;

  AudioPlayerBloc(this.songs) : super(AudioPlayerState()) {
    on<PlaySongEvent>(_onPlaySong);
    on<PauseSongEvent>(_onPauseSong);
    on<StopSongEvent>(_onStopSong);
    on<SeekSongEvent>(_onSeekSong);
    on<UpdateProgressEvent>(_onUpdateProgress);
    on<TogglePlayPauseEvent>(_onTogglePlayPause);
    on<PlayPreviousSongEvent>(_onPlayPrevious);
    on<PlayNextSongEvent>(_onPlayNext);
  }

  Future<void> _onPlaySong(
      PlaySongEvent event,
      Emitter<AudioPlayerState> emit,
      ) async {
    try {
      await _player.setFilePath(event.song.path);
      // Set duration immediately after loading
      final dur = _player.duration;
      if (dur != null) {
        emit(state.copyWith(duration: dur.inSeconds.toDouble()));
      }
      currentIndex = event.index;

      _player.play();

      emit(state.copyWith(
        currentSong: event.song.copyWith(isPlaying: true),
        isPlaying: true,
      ));

      // Listen to position updates
      _positionSubscription?.cancel();
      _positionSubscription = _player.positionStream.listen((pos) {
        add(UpdateProgressEvent(pos));
      });

      // // Listen to duration updates
      // _durationSubscription?.cancel();
      // _durationSubscription = _player.durationStream.listen((dur) {
      //   if (dur != null) {
      //     emit(state.copyWith(duration: dur.inSeconds.toDouble()));
      //   }
      // });

      // Listen to song completion
      _completionSubscription?.cancel();
      _completionSubscription =
          _player.processingStateStream.listen((processingState) {
            if (processingState == ProcessingState.completed) {
              add(PlayNextSongEvent());
            }
          });
    } catch (e) {
      print('Error playing song: $e');
    }
  }

  Future<void> _onPauseSong(
      PauseSongEvent event,
      Emitter<AudioPlayerState> emit,
      ) async {
    await _player.pause();
    emit(state.copyWith(isPlaying: false));
  }

  Future<void> _onStopSong(
      StopSongEvent event,
      Emitter<AudioPlayerState> emit,
      ) async {
    await _player.stop();
    emit(state.copyWith(isPlaying: false, position: 0));
  }

  Future<void> _onSeekSong(
      SeekSongEvent event,
      Emitter<AudioPlayerState> emit,
      ) async {
    final newPos = Duration(seconds: event.position.toInt());
    await _player.seek(newPos);
    emit(state.copyWith(position: event.position));
  }

  void _onUpdateProgress(
      UpdateProgressEvent event,
      Emitter<AudioPlayerState> emit,
      ) {
    emit(state.copyWith(position: event.position.inSeconds.toDouble()));
  }

  Future<void> _onTogglePlayPause(
      TogglePlayPauseEvent event,
      Emitter<AudioPlayerState> emit,
      ) async {
    if (_player.playing) {
      await _player.pause();
      emit(state.copyWith(isPlaying: false));
    } else {
       _player.play();
      emit(state.copyWith(isPlaying: true));
    }
  }

  Future<void> _onPlayNext(
      PlayNextSongEvent event,
      Emitter<AudioPlayerState> emit,
      ) async {
    if (songs.isEmpty) return;

    // Move to next song
    currentIndex = (currentIndex + 1) % songs.length;

    final nextSong = songs[currentIndex];

    add(PlaySongEvent(song: nextSong, index: currentIndex));
  }

  Future<void> _onPlayPrevious(
      PlayPreviousSongEvent event,
      Emitter<AudioPlayerState> emit,
      ) async {
    if (songs.isEmpty) return;

    // Move to previous
    currentIndex = (currentIndex - 1) < 0
        ? songs.length - 1
        : currentIndex - 1;

    final prevSong = songs[currentIndex];

    add(PlaySongEvent(song: prevSong, index: currentIndex));
  }

  @override
  Future<void> close() {
    _player.dispose();
    return super.close();
  }
}
