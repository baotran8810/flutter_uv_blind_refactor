part of '../app_semantics.dart';

class _AppSemanticsCustom extends StatelessWidget {
  final Widget child;
  final List<String> labelList;
  final String? langKey;
  final bool isFocused;
  final bool isButton;
  final bool isSlider;
  final bool isTextField;
  final bool? toggleValue;
  final bool isDocSemantic;
  final AppSemanticsController controller;
  final void Function() onDidGainAccessibilityFocus;
  final void Function() onDidLoseAccessibilityFocus;
  final void Function()? onDismiss;

  const _AppSemanticsCustom({
    Key? key,
    required this.child,
    required this.labelList,
    required this.langKey,
    required this.isFocused,
    required this.isButton,
    required this.isSlider,
    required this.isTextField,
    required this.toggleValue,
    required this.isDocSemantic,
    required this.controller,
    required this.onDidGainAccessibilityFocus,
    required this.onDidLoseAccessibilityFocus,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      focused: isFocused,
      // Workaround to hide VoiceOver on iOS
      label: Platform.isIOS ? _getWaitLabelForVoiceOver() : '‿',
      onDismiss: onDismiss,
      // Override semantics
      onDidGainAccessibilityFocus: () async {
        onDidGainAccessibilityFocus();

        final List<String> finalLabelList = [...labelList];

        // Button
        if (isButton) {
          finalLabelList.addAll(StringViewUtils.getScriptsTappable());
        }
        // Switcher
        else if (toggleValue != null) {
          finalLabelList.add(ConstScript.kSilence);
          finalLabelList.add(StringViewUtils.getOnOffStatus(toggleValue!));
          finalLabelList.addAll(StringViewUtils.getScriptsTappable());
        }
        // Slider
        else if (isSlider) {
          finalLabelList.add(StringViewUtils.getScriptSlider());
        }
        // TextField
        else if (isTextField) {
          finalLabelList.addAll(StringViewUtils.getScriptsEditable());
        }

        controller.speak(
          finalLabelList,
          langKey: langKey,
          isDocSemantic: isDocSemantic,
        );
      },
      onDidLoseAccessibilityFocus: onDidLoseAccessibilityFocus,
      child: ExcludeSemantics(
        child: child,
      ),
    );
  }

  /// iOS only: Workaround to make VoiceOver two-finger swipe-up/swipe-down work.
  ///
  /// Idea: We use "-,-," to "mimic" the wait and calculate the wait
  /// based on text's words count.
  String _getWaitLabelForVoiceOver() {
    String totalWait = '';

    const String WAIT_700MS = '-,-,';

    final tempLabelList = [...labelList];

    // * Apply silence keys & remove them from the list

    for (int i = tempLabelList.length - 1; i >= 0; i--) {
      final item = tempLabelList[i];
      if (item == ConstScript.kSilence) {
        totalWait += WAIT_700MS * 2;
        tempLabelList.removeAt(i);
      }
    }

    final int wordCount;
    final double wordsPer700ms;

    // * Calculate wordCount & wordsPer700ms PER LANGUAGE

    final currentLanguage = LocalizationUtils.getLanguage();
    switch (currentLanguage) {
      case SupportedLanguage.en:
        final tempSentence = tempLabelList.join(' ');
        wordCount = tempSentence.split(' ').length;
        if (wordCount < 10) {
          // Slow
          wordsPer700ms = 1;
        } else if (wordCount > 40) {
          // Fast
          wordsPer700ms = 1.7;
        } else {
          // Normal
          wordsPer700ms = 1.5;
        }
        break;
      case SupportedLanguage.ja:
        final tempSentence = tempLabelList.join();
        wordCount = tempSentence.length;
        if (wordCount < 10) {
          // Slow
          wordsPer700ms = 2;
        } else if (wordCount > 40) {
          // Fast
          wordsPer700ms = 3.25;
        } else {
          // Normal
          wordsPer700ms = 2.25;
        }
        break;
    }

    // ignore: join_return_with_assignment
    totalWait += WAIT_700MS * (wordCount / wordsPer700ms).floor();

    // * Buffer, mostly to wait for Polly to download
    totalWait += WAIT_700MS;

    return totalWait;
  }
}
