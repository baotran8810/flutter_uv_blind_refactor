import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/common/utility/miscs/speak_player.dart';
import 'package:flutter_uv_blind_refactor/common/utility/miscs/tts_player.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/tts_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/apis/rest_client.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/app_setting_repository/app_setting_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/analytics_service/analytics_service.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/hardware_service/hardware_service.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/speaking_service/speaking_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class SpeakingServiceImpl implements SpeakingService {
  final RestClient _restClient;

  final AppSettingRepository _appSettingRepository;
  final AnalyticsService _analyticsService;
  final HardwareService _hardwareService;

  SpeakingServiceImpl({
    required RestClient restClient,
    required AnalyticsService analyticsService,
    required AppSettingRepository appSettingRepository,
    required HardwareService hardwareService,
  })  : _restClient = restClient,
        _appSettingRepository = appSettingRepository,
        _analyticsService = analyticsService,
        _hardwareService = hardwareService {
    TtsUtils.init();
  }

  int _debounceCount = 0;
  bool _isPreventSpeaking = false;

  SpeakPlayer? _commonSpeakPlayerInternal;
  SpeakPlayer get _commonSpeakPlayer {
    _commonSpeakPlayerInternal ??= SpeakPlayer(
      pollyPlayer: AudioPlayer(
        handleInterruptions: false,
      ),
      ttsPlayer: TtsPlayer(),
      restClient: _restClient,
    );

    return _commonSpeakPlayerInternal!;
  }

  final Map<String, SpeakPlayer> _playerIdWithAudioPlayerMap = {};

  @override
  Future<void> clearCachedPollyFiles() async {
    final Directory appFolder = await getApplicationDocumentsDirectory();
    await _deleteFilesInFolder('${appFolder.path}/files');
  }

  @override
  Future<void> configAudioSession() async {
    final audioSession = await AudioSession.instance;

    await audioSession.configure(AudioSessionConfiguration(
      // * iOS
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      // Avoid audio players ducking when overlap with VO
      avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.duckOthers,
      // * Android
      androidAudioAttributes: AndroidAudioAttributes(
        // Prevent audio players from interrupting (stop) the speaking Talkback
        usage: AndroidAudioUsage.assistanceAccessibility,
      ),
    ));

    await audioSession.setActive(true);
  }

  Future<void> _deleteFilesInFolder(String folderPath) async {
    final dir = Directory(folderPath);
    if (!dir.existsSync()) {
      return;
    }

    final fileSysEntityList = dir.listSync();

    final List<Future> futureList = [];
    for (final fileListSysEntity in fileSysEntityList) {
      if (fileListSysEntity is File) {
        futureList.add(fileListSysEntity.delete());
      }
    }
    await Future.wait(futureList);
  }

  // TODO remove all duplicate functions of commonPlayer

  // ! Workaround to cancel speaking during generating
  // ! source file
  @override
  void cancelSpeaking() {
    _debounceCount++;
  }

  @override
  void startPreventSpeak() {
    _isPreventSpeaking = true;
  }

  @override
  void stopPreventSpeak() {
    _isPreventSpeaking = false;
  }

  @override
  Future<void> speakSentences(
    List<SpeakItem> speakItemList, {
    bool doCacheFile = true,
    double? speed,
    bool applyPitch = true,
  }) async {
    if (_isPreventSpeaking) {
      return;
    }

    final int tempDebounceCount = _debounceCount;

    pauseCommonPlayer();
    pauseAllPlayers();

    // TODO bring this to somewhere else more fitable
    final appSetting = await _appSettingRepository.getAppSetting();
    try {
      await _commonSpeakPlayer.setSource(
        speakItemList: speakItemList,
        gender: appSetting.readingGender,
        pitch: applyPitch ? appSetting.voicePitch : null,
        logPollyCountFunc: (textLength, langKey) {
          _analyticsService.logPollyCount(
            textLength: textLength,
            langKey: langKey,
          );
        },
      );
    } catch (e) {
      //
    }

    await _commonSpeakPlayer.setSpeed(1);

    if (tempDebounceCount == _debounceCount) {
      _hardwareService.enableWakelock();

      await _commonSpeakPlayer.play();

      _hardwareService.disableWakelock();
    }
  }

  @override
  Future<void> pauseCommonPlayer() async {
    await _commonSpeakPlayer.pause();
  }

  /// Return playerId
  @override
  Future<String> initPlayer() async {
    final String newPlayerId = Uuid().v4();
    print("asasasas" + newPlayerId);
    _playerIdWithAudioPlayerMap[newPlayerId] = SpeakPlayer(
      pollyPlayer: AudioPlayer(
        handleInterruptions: false,
      ),
      ttsPlayer: TtsPlayer(),
      restClient: _restClient,
    );

    return newPlayerId;
  }

  SpeakPlayer _getSpeakPlayer(String playerId) {
    final foundAudioPlayer = _playerIdWithAudioPlayerMap[playerId];

    if (foundAudioPlayer == null) {
      throw Exception(
        'CUSTOM: Unexpected: cannot find player with id: $playerId',
      );
    }

    return foundAudioPlayer;
  }

  @override
  Future<void> disposePlayer(String playerId) async {
    final speakPlayer = _getSpeakPlayer(playerId);

    await speakPlayer.dispose();
    _playerIdWithAudioPlayerMap.remove(playerId);
  }

  @override
  Future<void> setSource({
    required String playerId,
    required List<SpeakItem> speakItemList,
    required AppVoice appVoiceReadingPage,
  }) async {
    final speakPlayer = _getSpeakPlayer(playerId);

    // TODO bring this to somewhere else more fitable
    final appSetting = await _appSettingRepository.getAppSetting();
    await speakPlayer.setSource(
      speakItemList: speakItemList,
      gender: appSetting.readingGender,
      pitch: appSetting.voicePitch,
      logPollyCountFunc: (textLength, langKey) {
        _analyticsService.logPollyCount(
          textLength: textLength,
          langKey: langKey,
        );
      },
      appVoice: appVoiceReadingPage,
    );
  }

  @override
  Future<void> play(String playerId) async {
    final speakPlayer = _getSpeakPlayer(playerId);

    await _pauseAllPlayersExcept(playerId);
    await pauseCommonPlayer();

    _hardwareService.enableWakelock();

    await speakPlayer.play();

    _hardwareService.disableWakelock();
  }

  @override
  Future<void> pauseAllPlayers() async {
    await _pausePlayers(_playerIdWithAudioPlayerMap.values.toList());
  }

  Future<void> _pauseAllPlayersExcept(String playerId) async {
    final mapToPause =
        Map<String, SpeakPlayer>.from(_playerIdWithAudioPlayerMap)
          ..removeWhere((itemPlayerId, _) => playerId == itemPlayerId);

    final playerListToPause = mapToPause.values.toList();

    await _pausePlayers([...playerListToPause]);
  }

  Future<void> _pausePlayers(List<SpeakPlayer> speakPlayerList) async {
    final futureList = speakPlayerList.map((player) => player.pause());
    await Future.wait(futureList);
  }

  @override
  Future<void> togglePlayOrPause(String playerId) async {
    final player = _getSpeakPlayer(playerId);

    if (player.isPlaying) {
      await player.pause();
    } else {
      play(playerId);
    }
  }

  @override
  Future<void> stop(String playerId) async {
    final player = _getSpeakPlayer(playerId);

    await player.stop();
  }

  @override
  Future<void> playFromStart(String playerId) async {
    final player = _getSpeakPlayer(playerId);

    await player.seekToStart();
    await play(playerId);
  }

  @override
  Future<void> seekToNext(String playerId) async {
    final player = _getSpeakPlayer(playerId);
    await player.seekToNext();
  }

  @override
  Future<void> seekToPrevious(String playerId) async {
    final player = _getSpeakPlayer(playerId);
    await player.seekToPrevious();
  }

  @override
  Future<void> setSpeed(String playerId, double speed) async {
    final player = _getSpeakPlayer(playerId);
    await player.setSpeed(speed);
  }

  @override
  Future<void> toggleMute(String playerId) async {
    final player = _getSpeakPlayer(playerId);

    final isMuted = player.volume == 0;
    await player.setVolume(isMuted ? 1 : 0);
  }

  @override
  bool getIsPlaying(String playerId) {
    final player = _getSpeakPlayer(playerId);
    return player.isPlaying;
  }

  @override
  Stream<bool> getStreamIsPlaying(String playerId) {
    final audioPlayer = _getSpeakPlayer(playerId);

    return audioPlayer.isPlayingStream;
  }

  @override
  Stream<double> getStreamVolume(String playerId) {
    final audioPlayer = _getSpeakPlayer(playerId);

    return audioPlayer.volumeStream;
  }

  @override
  Stream<double> getStreamSpeed(String playerId) {
    final audioPlayer = _getSpeakPlayer(playerId);

    return audioPlayer.speedStream;
  }

  @override
  Stream<int?> getStreamCurrentIndex(String playerId) {
    final audioPlayer = _getSpeakPlayer(playerId);

    return audioPlayer.currentIndexStream;
  }

  @override
  Stream<ProcessingState> getStreamState(String playerId) {
    final audioPlayer = _getSpeakPlayer(playerId);

    return audioPlayer.processingStateStream;
  }
}
