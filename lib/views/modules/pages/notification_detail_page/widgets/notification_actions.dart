part of '../notification_detail_page.dart';

class _NotificationActions extends StatelessWidget {
  final NotificationAppDto notification;
  final bool hasLiked;
  final bool isLoadingLikedCount;
  final int currentLikedCount;
  final VoidCallback onPressedDecodeScaoCode;
  final VoidCallback onPressedLike;
  final VoidCallback onPressedShare;

  const _NotificationActions({
    Key? key,
    required this.notification,
    required this.hasLiked,
    required this.isLoadingLikedCount,
    required this.currentLikedCount,
    required this.onPressedDecodeScaoCode,
    required this.onPressedLike,
    required this.onPressedShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 260,
        padding: EdgeInsets.symmetric(vertical: AppDimens.paddingNormal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (notification.qrCode != null)
              Container(
                margin: EdgeInsets.only(bottom: 8),
                child: _buildActionBtn(
                  imgAssetUrl: AppAssets.iconUv,
                  semText: tra(LocaleKeys.semBtn_openAttachedCode),
                  text: tra(LocaleKeys.btn_openAttachedCode),
                  btnColor: Color(0xFFA21942),
                  onPressed: onPressedDecodeScaoCode,
                ),
              ),
            Row(
              children: [
                Expanded(
                  // * Like button
                  child: _buildActionBtn(
                    isLoading: isLoadingLikedCount,
                    iconData: Icons.thumb_up_alt_outlined,
                    semText: tra(LocaleKeys.semBtn_likeMessage),
                    text: tra(
                      LocaleKeys.btn_likeCountWA,
                      namedArgs: {'likeCount': currentLikedCount.toString()},
                    ),
                    btnColor: hasLiked ? Color(0xFFFD6925) : Color(0xFFD9D9D9),
                    textColor: hasLiked ? Colors.white : Color(0xFF595959),
                    onPressed: onPressedLike,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  // * Share button
                  child: _buildActionBtn(
                    iconData: Icons.share,
                    semText: tra(LocaleKeys.semBtn_shareMessage),
                    text: tra(LocaleKeys.btn_share),
                    btnColor: Color(0xFF0A97D9),
                    onPressed: onPressedShare,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBtn({
    bool isLoading = false,
    IconData? iconData,
    String? imgAssetUrl,
    required String semText,
    required String text,
    required Color btnColor,
    Color textColor = Colors.white,
    required void Function() onPressed,
  }) {
    return AppButtonNew(
      onPressed: onPressed,
      semanticLabel: semText,
      btnColor: btnColor,
      textColor: textColor,
      borderRadius: BorderRadius.circular(2),
      child: isLoading
          ? AppLoading(
              color: textColor,
              size: 24,
              lineWidth: 4,
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (iconData != null)
                  Container(
                    margin: EdgeInsets.only(
                      right: AppDimens.paddingTiny,
                    ),
                    child: Icon(
                      iconData,
                      size: 24,
                      // color: textColor,
                    ),
                  ),
                if (imgAssetUrl != null)
                  Container(
                    margin: EdgeInsets.only(
                      right: AppDimens.paddingTiny,
                    ),
                    child: Image.asset(
                      imgAssetUrl,
                      width: 24,
                      height: 24,
                    ),
                  ),
                Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
    );
  }
}
