import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';

abstract class VoiceInputService {
  /// return `null` if cannot recognize
  VoiceDecodedResult? decodeVoiceInput(String voiceInput);
}

class VoiceDecodedResult {
  final VoiceSearchCriteria searchCriteria;
  final VoiceAction action;

  VoiceDecodedResult({
    required this.searchCriteria,
    required this.action,
  });

  String getSpeechStr() {
    final String? dateStr = searchCriteria.dateRange?.originalDateRangeInput;
    final String? keyword = searchCriteria.keyword;

    final String speech;

    switch (LocalizationUtils.getLanguage()) {
      case SupportedLanguage.ja:
        // {dateStr}の{keyword}
        speech = [
          if (dateStr != null) dateStr,
          if (keyword != null) keyword,
        ].join('の');
        break;
      case SupportedLanguage.en:
        // {keyword} on {dateStr}
        speech = [
          if (keyword != null) keyword,
          if (dateStr != null) dateStr,
        ].join(' on ');
        break;
    }

    return speech;
  }
}

enum VoiceAction {
  reading,
  listing,
}

class VoiceSearchCriteria {
  final DateRange? dateRange;
  final String? keyword;

  VoiceSearchCriteria({
    this.dateRange,
    this.keyword,
  });
}

class DateRange {
  final DateTime fromDate;
  final DateTime toDate;
  final String originalDateRangeInput;

  DateRange({
    DateTime? fromDate,
    required this.toDate,
    required this.originalDateRangeInput,
  }) : fromDate = fromDate ?? DateTime(1700);
}
