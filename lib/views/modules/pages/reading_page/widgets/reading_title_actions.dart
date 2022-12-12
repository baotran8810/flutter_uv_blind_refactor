part of '../reading_page.dart';

class _TitleActions extends StatelessWidget {
  // Player status
  final bool isPlaying;
  final bool isCompleted;
  final bool isPlayingAutoplay;

  final void Function() onPressedPlayPause;

  const _TitleActions({
    Key? key,
    required this.isPlaying,
    required this.isCompleted,
    required this.isPlayingAutoplay,
    required this.onPressedPlayPause,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDisplayPlay = isCompleted || !isPlaying;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: AppButtonNew(
        semanticId: getSemanticsIdOfPageTitle(Get.currentRoute),
        onPressed: () {
          onPressedPlayPause();
        },
        suffixLabelList: isPlayingAutoplay
            ? []
            : [
                tra(LocaleKeys.semBtn_titleReading1),
                ConstScript.kSilence,
                tra(LocaleKeys.semBtn_titleReading2),
              ],
        readSemanticBtn: !isPlayingAutoplay,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              color: Colors.white,
            ),
            children: [
              TextSpan(
                text: isDisplayPlay
                    ? tra(LocaleKeys.btn_startReading)
                    : tra(LocaleKeys.btn_stopReading),
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child:
                    isDisplayPlay ? Icon(Icons.play_arrow) : Icon(Icons.pause),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AutoplaySwitcher extends StatelessWidget {
  final bool isAutoplayReading;
  final void Function(bool newValue) onChangedAutoplay;

  const _AutoplaySwitcher({
    Key? key,
    required this.isAutoplayReading,
    required this.onChangedAutoplay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ExcludeSemantics(
            child: Text(
              tra(LocaleKeys.txt_autoplay),
              style: TextStyle(
                fontSize: 12,
                height: 1,
              ),
            ),
          ),
          Container(
            // Workaround because we cannot adjust switcher's size
            // height should match with scale
            height: 26,
            child: Transform.scale(
              scale: 0.8,
              child: AppSwitcher(
                semanticsLabel: tra(LocaleKeys.semTxt_autoplay),
                currentValue: isAutoplayReading,
                onChanged: (newValue) {
                  onChangedAutoplay(newValue);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
