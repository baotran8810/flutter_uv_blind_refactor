import 'package:flutter_uv_blind_refactor/common/utility/utils/log_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/voice_input_service/voice_input_service.dart';

class VoiceInputServiceImpl implements VoiceInputService {
  @override
  VoiceDecodedResult? decodeVoiceInput(String voiceInput) {
    final String cmdNoundsSet = _PossibleText.commandNoun.join('|');
    final String cmdSeparatorsSet = _PossibleText.commandSeparator.join('|');
    final String cmdVerbsSet = [
      ..._PossibleText.commandVerbRead,
      ..._PossibleText.commandVerbList,
    ].join('|');

    final sentenceRegEx =
        RegExp('(.*)($cmdNoundsSet)($cmdSeparatorsSet)($cmdVerbsSet)');

    final List<Match> sentenceMatches =
        sentenceRegEx.allMatches(voiceInput).toList();

    if (sentenceMatches.isEmpty) {
      return null;
    }

    final sentenceMatch = sentenceMatches[0];

    final String textOfDateRangeAndKeyword = sentenceMatch.group(1)!;
    final String cmdVerbText = sentenceMatch.group(4)!;

    final VoiceSearchCriteria searchCriteria =
        _extractDateRangeAndKeyword(textOfDateRangeAndKeyword);

    VoiceAction voiceAction;
    if (_PossibleText.commandVerbRead.contains(cmdVerbText)) {
      voiceAction = VoiceAction.reading;
    } else if (_PossibleText.commandVerbList.contains(cmdVerbText)) {
      voiceAction = VoiceAction.listing;
    } else {
      // This case won't be likely to happen because we already
      // search with Regex in `sentenceRegEx`
      LogUtils.e('Parsing voiceAction unexpected error');
      return null;
    }

    return VoiceDecodedResult(
      searchCriteria: searchCriteria,
      action: voiceAction,
    );
  }

  VoiceSearchCriteria _extractDateRangeAndKeyword(String input) {
    final String separatorsSet = _PossibleText.separator.join('|');
    final groupText =
        input.split(RegExp(separatorsSet)).where((x) => x.isNotEmpty);

    DateRange? extractedDateRange;
    String? extractedKeyword;

    for (final textToExtract in groupText) {
      if (extractedDateRange != null) {
        extractedKeyword = textToExtract;
        break;
      }

      // First, try to extract date range from text
      final matchDateRange = _extractDateRange(textToExtract);

      if (matchDateRange != null) {
        extractedDateRange = matchDateRange;
      }
      // If failed to export DateRange, use textToExtract as Keyword
      else {
        extractedKeyword = textToExtract;
      }

      if (extractedDateRange != null && extractedKeyword != null) {
        break;
      }
    }

    return VoiceSearchCriteria(
      dateRange: extractedDateRange,
      keyword: extractedKeyword,
    );
  }

  DateRange? _extractDateRange(String input) {
    final DateTime now = DateTime.now();

    // * 1: Extract all basic data from input
    final _FuzzyTime? extractedFuzzyTime = _extractFuzzyTime(input);

    final _GetTimeType extractedGetTimeType = _extractGetTimeType(input);

    final int? extractedYear =
        _extractNumberFromDateStr(input, extractType: _DMY.year);
    final int? extractedMonth =
        _extractNumberFromDateStr(input, extractType: _DMY.month);
    final int? extractedDay =
        _extractNumberFromDateStr(input, extractType: _DMY.day);

    // * 2: Return if fuzzyTime is "thisWeek" | "lastWeek"
    if (extractedFuzzyTime == _FuzzyTime.lastWeek ||
        extractedFuzzyTime == _FuzzyTime.thisWeek) {
      final nowWithoutTime = DateTime(now.year, now.month, now.day);

      final firstDayOfWeek = extractedFuzzyTime == _FuzzyTime.lastWeek
          ? nowWithoutTime.subtract(Duration(days: nowWithoutTime.weekday - 7))
          : nowWithoutTime.subtract(Duration(days: nowWithoutTime.weekday));

      return DateRange(
        fromDate: firstDayOfWeek,
        toDate: firstDayOfWeek.add(Duration(days: 7)),
        originalDateRangeInput: input,
      );
    }

    int? day;
    int? month;
    int? year;

    // * 3: Assign day/month/year based on fuzzyTime
    switch (extractedFuzzyTime) {
      case _FuzzyTime.today:
        day = now.day;
        break;
      case _FuzzyTime.yesterday:
        day = now.subtract(Duration(days: 1)).day;
        break;
      case _FuzzyTime.thisMonth:
        month = now.month;
        break;
      case _FuzzyTime.lastMonth:
        month = now.subtract(Duration(days: 1)).month;
        break;
      case _FuzzyTime.thisYear:
        year = now.year;
        break;
      case _FuzzyTime.lastYear:
        year = now.subtract(Duration(days: 1)).year;
        break;
      case null:
        break;
      // Already check and return above so
      // this is just to ignore the lint
      case _FuzzyTime.thisWeek:
      case _FuzzyTime.lastWeek:
        return null;
    }

    // * 4: Fill in unassigned d/m/y based on extracted d/m/y
    day ??= extractedDay;
    month ??= extractedMonth;
    year ??= extractedYear;

    // * 5: Fill in d/m/y if there isn't any in (3) & (4)
    // Example: January => January of this year
    DateTime specificDate;
    if (day != null) {
      specificDate = DateTime(year ?? now.year, month ?? now.month, day);
    }
    // day == null
    else if (month != null) {
      specificDate = DateTime(year ?? now.year, month);
    }
    // day == null && month == null
    else if (year != null) {
      specificDate = DateTime(year);
    }
    // day == null && month == null && year == null
    else {
      return null;
    }

    DateTime? fromDate;
    DateTime? toDate;

    // * 6: Adjust & assign from/to to final result based on extractedGetTimeType
    switch (extractedGetTimeType) {
      case _GetTimeType.exactly:
        if (day != null) {
          // Within this day
          fromDate = specificDate;
          toDate = fromDate.add(Duration(days: 1));
        }
        // dayy == null
        else if (month != null) {
          // Within this month
          fromDate = specificDate;
          toDate = fromDate.add(Duration(days: 31)); // TODO correct
        }
        // day == null && month == null
        else if (year != null) {
          // Within this year
          fromDate = specificDate;
          toDate = fromDate.add(Duration(days: 365)); // TODO correct
        }
        // day == null && month == null && year == null
        else {
          return null;
        }
        break;
      case _GetTimeType.before:
        toDate = specificDate;
        break;
      case _GetTimeType.after:
        fromDate = specificDate;
        toDate = DateTime.now();
        break;
    }

    return DateRange(
      fromDate: fromDate,
      toDate: toDate,
      originalDateRangeInput: input,
    );
  }

  bool _isContain(String input, List<String> possibleWordList) {
    return possibleWordList.any((possibleWord) => input.contains(possibleWord));
  }

  int? _extractNumberFromDateStr(
    String input, {
    required _DMY extractType,
  }) {
    late final RegExp regex;
    switch (extractType) {
      case _DMY.day:
        // 2017年
        regex = RegExp('(\\d{1,2})(${_PossibleText.day.join('|')})');
        break;
      case _DMY.month:
        // 9月
        regex = RegExp('(\\d{1,2})(${_PossibleText.month.join('|')})');
        break;
      case _DMY.year:
        // 22日
        regex = RegExp('(\\d{4})(${_PossibleText.year.join('|')})');
        break;
    }

    final matches = regex.allMatches(input).toList();
    if (matches.isNotEmpty) {
      final String? numberStr = matches[0].group(1);
      return int.tryParse(numberStr ?? '');
    }
  }

  _FuzzyTime? _extractFuzzyTime(String input) {
    if (_isContain(input, _PossibleText.today)) {
      return _FuzzyTime.today;
    }

    if (_isContain(input, _PossibleText.yesterday)) {
      return _FuzzyTime.yesterday;
    }

    if (_isContain(input, _PossibleText.thisMonth)) {
      return _FuzzyTime.thisMonth;
    }

    if (_isContain(input, _PossibleText.lastMonth)) {
      return _FuzzyTime.lastMonth;
    }

    if (_isContain(input, _PossibleText.thisYear)) {
      return _FuzzyTime.thisYear;
    }

    if (_isContain(input, _PossibleText.lastYear)) {
      return _FuzzyTime.lastYear;
    }

    if (_isContain(input, _PossibleText.thisWeek)) {
      return _FuzzyTime.thisWeek;
    }

    if (_isContain(input, _PossibleText.lastWeek)) {
      return _FuzzyTime.lastWeek;
    }

    return null;
  }

  _GetTimeType _extractGetTimeType(String input) {
    if (_isContain(input, _PossibleText.after)) {
      return _GetTimeType.after;
    }

    if (_isContain(input, _PossibleText.before)) {
      return _GetTimeType.before;
    }

    return _GetTimeType.exactly;
  }
}

class _PossibleText {
  static const commandNoun = ['ファイル', 'ノート'];
  static const commandSeparator = ['を'];
  static const commandVerbRead = ['読み上げる', '読んでください', '読んで下さい', '読む', 'よむ'];
  static const commandVerbList = [
    '探す',
    '見る',
    'みる',
    '検索する',
    '探してください',
    '検索してください',
    '探して下さい',
    '検索して下さい',
  ];

  static const separator = ['の'];

  static const today = ['今日'];
  static const yesterday = ['昨日'];
  static const thisMonth = ['今月'];
  static const lastMonth = ['先月'];
  static const thisYear = ['今年'];
  static const lastYear = ['先年'];
  static const thisWeek = ['今週'];
  static const lastWeek = ['先週'];

  static const after = ['以降', '以後'];
  static const before = ['以前'];

  static const year = ['年'];
  static const month = ['月'];
  static const day = ['日'];
}

enum _DMY { day, month, year }

enum _FuzzyTime {
  today,
  yesterday,
  thisMonth,
  lastMonth,
  thisYear,
  lastYear,
  thisWeek,
  lastWeek,
}

enum _GetTimeType {
  exactly,
  before,
  after,
}
