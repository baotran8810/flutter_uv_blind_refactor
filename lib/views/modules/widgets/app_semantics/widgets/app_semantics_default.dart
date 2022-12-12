part of '../app_semantics.dart';

class _AppSemanticsDefault extends StatelessWidget {
  final Widget child;
  final List<String> labelList;
  final bool isFocused;
  final bool isButton;
  final bool isSlider;
  final bool isTextField;
  final bool? toggleValue;
  final void Function() onDidGainAccessibilityFocus;
  final void Function() onDidLoseAccessibilityFocus;
  final void Function()? onDismiss;

  const _AppSemanticsDefault({
    Key? key,
    required this.child,
    required this.labelList,
    required this.isFocused,
    required this.isButton,
    required this.isSlider,
    required this.isTextField,
    required this.toggleValue,
    required this.onDidGainAccessibilityFocus,
    required this.onDidLoseAccessibilityFocus,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      focused: isFocused,
      label: labelList
          .map((labelItem) {
            if (labelItem == ConstScript.kSilence) {
              return Platform.isIOS ? '-,-,' : '‿‿';
            }

            return labelItem;
          })
          .toList()
          .join('. '),
      // Native controls
      button: isButton,
      slider: isSlider,
      textField: isTextField,
      toggled: toggleValue,

      // Make z-scrub work on iOS
      onDismiss: onDismiss,
      onDidGainAccessibilityFocus: onDidGainAccessibilityFocus,
      onDidLoseAccessibilityFocus: onDidLoseAccessibilityFocus,
      child: ExcludeSemantics(
        child: child,
      ),
    );
  }
}
