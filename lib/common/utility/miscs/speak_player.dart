import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_uv_blind_refactor/common/theme/assets.dart';
import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/common/utility/extensions/double_extension.dart';
import 'package:flutter_uv_blind_refactor/common/utility/miscs/tts_player.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/a11y_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/log_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/apis/rest_client.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/app_setting/app_setting_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/speech/get_speech_request_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/speech/get_speech_response_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/speaking_service/speaking_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class SpeakPlayer {
  bool usePollyPlayer = false;

  final AudioPlayer pollyPlayer;
  final TtsPlayer ttsPlayer;

  final RestClient _restClient;

  SpeakPlayer({
    required this.pollyPlayer,
    required this.ttsPlayer,
    required RestClient restClient,
  }) : _restClient = restClient;

  /// Throw [UnsupportedLanguageException] if cannot get polly AND tts
  Future<void> setSource({
    required List<SpeakItem> speakItemList,
    required Gender gender,
    double? pitch,
    AppVoice? appVoice,
    required void Function(int textLength, String langKey) logPollyCountFunc,
  }) async {
    final bool isBlindMode = await A11yUtils.isBlindModeOn();
    if (!isBlindMode) {
      final pollyAudioSource = await _getPollyAudioSource(
        speakItemList: speakItemList,
        gender: gender,
        pitch: pitch,
        logPollyCountFunc: logPollyCountFunc,
      );

      if (pollyAudioSource == null) {
        // Use TTS Player
        usePollyPlayer = false;

        await ttsPlayer.setSource(speakItemList: speakItemList);
        if (pitch != null) {
          ttsPlayer.setPitch(pitch);
        }
      } else {
        // Use Polly Player
        usePollyPlayer = true;

        await pollyPlayer.setAudioSource(pollyAudioSource);
      }
    } else {
      switch (appVoice) {
        case AppVoice.univoice:
          final pollyAudioSource = await _getPollyAudioSource(
            speakItemList: speakItemList,
            gender: gender,
            pitch: pitch,
            logPollyCountFunc: logPollyCountFunc,
          );
          if (pollyAudioSource != null) {
            usePollyPlayer = true;
            await pollyPlayer.setAudioSource(pollyAudioSource);
          } else {
            usePollyPlayer = false;
            throw UnsupportedLanguageException(
                speakItemList.first.langKey ?? ".jpn");
          }
          break;
        default:
          usePollyPlayer = false;

          await ttsPlayer.setSource(speakItemList: speakItemList);
          if (pitch != null) {
            ttsPlayer.setPitch(pitch);
          }
      }
    }
  }

  Future<void> dispose() async {
    usePollyPlayer ? pollyPlayer.dispose() : ttsPlayer.dispose();
  }

  bool get isPlaying {
    return usePollyPlayer ? pollyPlayer.playing : ttsPlayer.isPlaying;
  }

  double get volume {
    return usePollyPlayer ? pollyPlayer.volume : ttsPlayer.volume;
  }

  Stream<bool> get isPlayingStream {
    return usePollyPlayer
        ? pollyPlayer.playingStream
        : ttsPlayer.getStreamIsPlaying();
  }

  Stream<double> get speedStream {
    return usePollyPlayer
        ? pollyPlayer.speedStream
        : ttsPlayer.getStreamSpeed();
  }

  Stream<double> get volumeStream {
    return usePollyPlayer
        ? pollyPlayer.volumeStream
        : ttsPlayer.getStreamVolume();
  }

  Stream<int?> get currentIndexStream {
    return usePollyPlayer
        ? pollyPlayer.currentIndexStream
        : ttsPlayer.getStreamCurrentIndex();
  }

  Stream<ProcessingState> get processingStateStream {
    return usePollyPlayer
        ? pollyPlayer.processingStateStream
        : ttsPlayer.getStreamProcessingState();
  }

  Future<void> setSpeed(double speed) async {
    usePollyPlayer
        ? await pollyPlayer.setSpeed(speed)
        : await ttsPlayer.setSpeed(speed);
  }

  Future<void> setVolume(double volume) async {
    usePollyPlayer
        ? await pollyPlayer.setVolume(volume)
        : await ttsPlayer.setVolume(volume);
  }

  Future<void> play() async {
    usePollyPlayer ? await pollyPlayer.play() : await ttsPlayer.play();
  }

  Future<void> pause() async {
    usePollyPlayer ? await pollyPlayer.pause() : await ttsPlayer.pause();
  }

  Future<void> stop() async {
    usePollyPlayer ? await pollyPlayer.stop() : await ttsPlayer.stop();
  }

  Future<void> seekToNext() async {
    usePollyPlayer
        ? await pollyPlayer.seekToNext()
        : await ttsPlayer.seekToNext();
  }

  Future<void> seekToPrevious() async {
    if (usePollyPlayer) {
      if (pollyPlayer.currentIndex == 0) {
        await pollyPlayer.seek(Duration.zero);
      } else {
        await pollyPlayer.seekToPrevious();
      }
    } else {
      await ttsPlayer.seekToPrevious();
    }
  }

  Future<void> seekToStart() async {
    if (usePollyPlayer) {
      await pollyPlayer.seek(Duration.zero, index: 0);
    } else {
      await ttsPlayer.seekToStart();
    }
  }

  /// Return `null` if polly is not available
  Future<ConcatenatingAudioSource?> _getPollyAudioSource({
    required List<SpeakItem> speakItemList,
    required Gender gender,
    required double? pitch,
    required void Function(int textLength, String langKey) logPollyCountFunc,
  }) async {
    List<String> filePathList = [];

    final futureList = speakItemList.map(
      (speakItem) {
        final langKey = speakItem.langKey ??
            LocalizationUtils.getCurrentLangKey() ??
            '.jpn';

        return _getPollyFilePath(
          sentence: speakItem.text,
          langKey: langKey,
          gender: gender,
          pitch: pitch,
          logPollyCountFunc: logPollyCountFunc,
        );
      },
    ).toList();

    try {
      filePathList = await Future.wait(futureList);
    } on PollyException {
      return null;
    }

    final audioSource = ConcatenatingAudioSource(
      children: filePathList
          .map((filePath) => AudioSource.uri(Uri.parse(filePath)))
          .toList(),
    );

    return audioSource;
  }

  /// Throw [PollyException] if failed to fetch polly
  Future<String> _getPollyFilePath({
    required String sentence,
    required String langKey,
    required Gender gender,
    required double? pitch,
    required void Function(int textLength, String langKey) logPollyCountFunc,
  }) async {
    if (sentence == ConstScript.kSilence) {
      return 'asset:///${AppSoundAssets.soundSilence500ms}';
    }

    final String fileNameToEndcode =
        langKey + gender.toString() + pitch.toString() + sentence;
    final String fileName =
        md5.convert(utf8.encode(fileNameToEndcode)).toString();

    try {
      final String filePath = await _generatePollySpeakFile(
        sentence: sentence,
        fileName: fileName,
        langKey: langKey,
        gender: gender,
        pitch: pitch,
        logPollyCountFunc: logPollyCountFunc,
      );

      return 'file:///$filePath';
    } catch (e) {
      throw PollyException();
    }
  }

  // * Polly

  Future<String> _generatePollySpeakFile({
    required String sentence,
    required String fileName,
    required String langKey,
    required Gender gender,
    required double? pitch,
    required void Function(int textLength, String langKey) logPollyCountFunc,
  }) async {
    final Directory appFolder = await getApplicationDocumentsDirectory();
    final Directory subDir = Directory('${appFolder.path}/files');

    if (!await subDir.exists()) {
      await subDir.create();
    }

    final String pollyFilePath = "${subDir.path}/$fileName-polly.mp3";

    final isFileExisted = await File(pollyFilePath).exists();
    if (isFileExisted) {
      return pollyFilePath;
    }

    double? pitchPercent = pitch?.map(
      inputMin: SpeakingPitchRange.kMin,
      inputMax: SpeakingPitchRange.kMax,
      outputMin: -25,
      outputMax: 50,
    );
    pitchPercent = pitchPercent?.toDoubleAsFixed(2);

    final getSpeechResponse = await _restClient.getSpeech(
      GetSpeechRequestDto(
        keyword: '',
        sentence: sentence,
        gender: gender,
        langKey: langKey,
        options: SpeechReqOptionsDto(
          pitchPercent: pitchPercent,
        ),
      ),
    );

    if (getSpeechResponse.data.source == SpeechSource.polly) {
      logPollyCountFunc(sentence.length, langKey);
    }

    LogUtils.iNoST(
      'Speech source: ${getSpeechResponse.data.source}',
    );

    final File newFile = await File(pollyFilePath)
        .writeAsBytes(getSpeechResponse.data.mp3Stream.data);

    return newFile.path;
  }
}

class PollyException implements Exception {
  PollyException();
}
