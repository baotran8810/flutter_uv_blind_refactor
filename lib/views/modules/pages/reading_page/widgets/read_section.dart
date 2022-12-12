part of '../reading_page.dart';

class _ReadSection extends StatelessWidget {
  final ReadingPageController controller;

  const _ReadSection({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.paddingNormal),
      child: Obx(() {
        final bool isLoading = controller.isLoading;
        final bool isTalkback = controller.isBlindModeOn;

        if (isTalkback) {
          return _buildContentTalkbackOn();
        } else {
          return !isLoading
              ? _buildContentTalkbackOff(context)
              : Center(
                  child: CircularProgressIndicator(),
                );
        }
      }),
    );
  }

  Widget _buildContentTalkbackOff(BuildContext context) {
    return Obx(
      () {
        final currentVolume = controller.currentVolume;
        final currentSpeed = controller.currentSpeed;
        final isPlaying = controller.isPlaying;
        final currentPlayerIndex = controller.currentPlayerIndex;
        final isCompleted = controller.isCompleted;

        final textControllerTitle = controller.textControllerTitle;
        final sentenceList = controller.sentenceList;
        final int sentenceListLength = sentenceList.length;
        final keys = controller.sentenceWidgetKeys;
        final String? originalUrl = controller.originalUrl;

        // Is not muted
        final bool isEnabled = currentVolume > 0;
        return Column(
          children: [
            Opacity(
              opacity: isEnabled ? 1 : 0.5,
              child: Row(
                children: [
                  _buildPlayerActionBtn(
                    label: tra(LocaleKeys.btn_backward),
                    onPressed: () {
                      if (isEnabled) {
                        controller.seekToPrevious();
                      }
                    },
                    imgAsset: AppAssets.iconPrevious,
                  ),
                  _buildPlayerActionBtn(
                    label: isCompleted
                        ? tra(LocaleKeys.btn_play)
                        : tra(LocaleKeys.btn_pause),
                    onPressed: () {
                      if (!isEnabled) {
                        return;
                      }

                      if (isCompleted) {
                        controller.playFromStart();
                      } else {
                        controller.togglePlayOrPause();
                      }
                    },
                    imgAsset: isCompleted
                        ? AppAssets.iconPlay
                        : isPlaying
                            ? AppAssets.iconPause
                            : AppAssets.iconPlay,
                  ),
                  _buildPlayerActionBtn(
                    label: tra(LocaleKeys.btn_forward),
                    onPressed: () {
                      if (isEnabled) {
                        controller.seekToNext();
                      }
                    },
                    imgAsset: AppAssets.iconNext,
                  ),
                  _buildPlayerActionBtn(
                    label: tra(LocaleKeys.btn_replay),
                    onPressed: () {
                      if (isEnabled) {
                        controller.playFromStart();
                      }
                    },
                    imgAsset: AppAssets.iconReset,
                  ),
                  Expanded(
                    child: Slider(
                      label: tra(LocaleKeys.semTxt_changeReadingSpeed),
                      value: currentSpeed,
                      min: 0.5,
                      max: 2.0,
                      onChanged: (double value) {
                        if (isEnabled) {
                          controller.setSpeed(value);
                        }
                      },
                    ),
                  ),
                  _buildPlayerActionBtn(
                    label: tra(LocaleKeys.btn_mute),
                    onPressed: () {
                      controller.toggleMute();
                    },
                    imgAsset: currentVolume == 1.0
                        ? AppAssets.iconVoiceOn
                        : AppAssets.iconVoiceOff,
                  ),
                ],
              ),
            ),
            SizedBox(height: AppDimens.paddingNormal),
            SizedBox(height: AppDimens.paddingNormal),
            _buildTitleTextField(textControllerTitle),
            SizedBox(height: AppDimens.paddingNormal),
            Expanded(
              child: _buildContentBox(
                child: Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                    ),
                    children: Iterable.generate(sentenceListLength, (i) => i)
                        .expand((i) => [
                              WidgetSpan(
                                child: SizedBox.fromSize(
                                  size: Size.zero,
                                  key: keys[i],
                                ),
                              ),
                              LinkifyViewUtils.getTextSpan(
                                sentenceList[i],
                                i != currentPlayerIndex
                                    ? Colors.black
                                    : AppColors.burgundyRed,
                              )
                            ])
                        .toList(),
                  ),
                ),
              ),
            ),
            if (originalUrl != null) ...{
              _buildUrlBox(originalUrl: originalUrl),
            }
          ],
        );
      },
    );
  }

  Widget _buildContentTalkbackOn() {
    final String? originalUrl = controller.originalUrl;
    return Obx(
      () {
        final textControllerTitle = controller.textControllerTitle;
        final sentenceList = controller.sentenceList;
        final selectedLangKey = controller.selectedLangKey;

        return Column(
          children: [
            SizedBox(height: AppDimens.paddingNormal),
            _buildTitleTextField(textControllerTitle),
            SizedBox(height: AppDimens.paddingNormal),
            Expanded(
              child: _buildContentBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: sentenceList
                      .map(
                        (sentence) => AppSemantics(
                          appVoiceReadingPage: controller.appVoiceReadingPage,
                          labelList: [
                            sentence,
                            if (LinkifyViewUtils.isHyperlink(sentence)) ...{
                              tra(LocaleKeys.semTxt_link)
                            }
                          ],
                          langKey: selectedLangKey,
                          isDocSemantic: true,
                          child: Container(
                            child: GestureDetector(
                              onTap: () {
                                LinkifyViewUtils.launchText(sentence);
                              },
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    height: 1.55,
                                  ),
                                  children: [
                                    LinkifyViewUtils.getTextSpan(
                                      sentence.replaceFirst("\n", ""),
                                      Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            if (originalUrl != null) ...{
              _buildUrlBox(originalUrl: originalUrl),
            }
          ],
        );
      },
    );
  }

  Widget _buildPlayerActionBtn({
    required void Function() onPressed,
    required String imgAsset,
    required String label,
  }) {
    return AppSemantics(
      labelList: [label],
      isButton: true,
      child: GestureDetector(
        onTap: onPressed,
        child: Image.asset(
          imgAsset,
          width: 48,
          height: 48,
        ),
      ),
    );
  }

  Widget _buildTitleTextField(TextEditingController textController) {
    return AppSemantics(
      labelList: [
        tra(
          LocaleKeys.txt_titleIsWA,
          namedArgs: {'title': textController.text},
        ),
      ],
      isTextField: true,
      child: TextFormField(
        onChanged: (value) {
          controller.changeTitle();
        },
        controller: textController,
        style: TextStyle(
          fontSize: 18,
          color: AppColors.textBlack,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          isDense: false,
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentBox({
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          width: double.infinity,
          child: child,
        ),
      ),
    );
  }

  Widget _buildUrlBox({required String originalUrl}) {
    if (originalUrl != "") {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: AppDimens.paddingNormal),
        child: InkWell(
            child: Container(
              width: double.infinity,
              child: Text(
                tra(LocaleKeys.txt_originalUrl),
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            onTap: () => launch(originalUrl)),
      );
    }
    return Container();
  }
}
