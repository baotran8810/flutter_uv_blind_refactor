part of '../notification_list_page.dart';

const double _imageSize = 68;

class _NotificationItem extends StatelessWidget {
  final NotificationAppDto notification;
  final void Function() onPressedItem;

  const _NotificationItem({
    Key? key,
    required this.notification,
    required this.onPressedItem,
  }) : super(key: key);

  /// Workaround to filter out the "picture" attachment
  List<NotifAttachmentDto> _getAttachmentList() {
    if (notification.attachmentList == null) {
      return [];
    }

    return notification.attachmentList!
        .where((attachment) => attachment.type != AttachmentType.picture)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final attachmentList = _getAttachmentList();
    final sentTime = DateTimeUtils.formatDateTimeShort(
      notification.lastPushAt,
    );

    final String semanticsText = tra(
      LocaleKeys.semBtn_notificationItemWA,
      namedArgs: {
        'sentTime': sentTime,
        'company': notification.company?.companyName ?? '',
        'title': notification.getTitle(),
        'content': notification.getContent(),
      },
    );

    // Use GestureDetector instead of InkWell because InkWell's `excludeFromSemantics` doesn't work
    return GestureDetector(
      excludeFromSemantics: true,
      onTap: () {
        onPressedItem();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.paddingNormal,
          vertical: AppDimens.paddingNormal,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]!),
          ),
        ),
        child: Column(
          children: [
            AppSemantics(
              labelList: [
                semanticsText,
                if (notification.hasRead == false)
                  tra(LocaleKeys.semTxt_unreadMessage)
              ],
              isButton: true,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildThumbnail(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            children: [
                              if (!notification.hasRead)
                                TextSpan(
                                  text: 'New  ',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                  ),
                                ),
                              TextSpan(
                                text: notification.getTitle(),
                                style: TextStyle(
                                  color: !notification.hasRead
                                      ? Color(0xFF0A97D9)
                                      : Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          notification.getContent(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFF2D2C2C),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppDimens.paddingNormal),
            Row(
              children: [
                Expanded(
                  child: ExcludeSemantics(
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: AppDimens.paddingTiny),
                          width: _imageSize,
                          child: (notification.qrCode != null ||
                                  (attachmentList.isNotEmpty))
                              ? Row(
                                  children: [
                                    if (notification.qrCode != null)
                                      Container(
                                        margin: EdgeInsets.only(right: 4),
                                        child: Image.asset(
                                          AppAssets.boxAttachmentUv,
                                          width: 16,
                                          height: 16,
                                        ),
                                      ),
                                    ...attachmentList
                                        .map((attachment) =>
                                            _buildAttachmentIcon(attachment))
                                        .toList(),
                                  ],
                                )
                              : SizedBox(),
                        ),
                        Expanded(
                          child: notification.company != null
                              ? _buildSubInfo(
                                  icon: Icons.house,
                                  text: notification.company!.companyName,
                                  isTextExpanded: true,
                                )
                              : SizedBox(),
                        ),
                        if (notification.company != null)
                          SizedBox(width: AppDimens.paddingSmall),
                        _buildSubInfo(
                          icon: Icons.access_time,
                          text: DateTimeUtils.formatDateTimeShort(
                            notification.lastPushAt,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Get the "picture" attachment to display as thumbnail
  Widget _buildThumbnail() {
    final foundPictureAttachment =
        notification.attachmentList?.firstWhereOrNull(
      (attachment) => attachment.type == AttachmentType.picture,
    );

    if (foundPictureAttachment == null) {
      return SizedBox();
    }

    return Container(
      margin: EdgeInsets.only(right: AppDimens.paddingSmall),
      child: AppNetworkImage(
        imageUrl: foundPictureAttachment.url,
        defaultImageAsset: AppAssets.notificationDefault,
        width: _imageSize,
        height: _imageSize,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildAttachmentIcon(NotifAttachmentDto attachment) {
    return Container(
      width: 16,
      height: 16,
      margin: EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        border: Border.all(
          color: Color(0xFFA5A5A5),
        ),
      ),
      child: Center(
        child: Icon(
          attachment.type.getIconData(),
          size: 10,
          color: Color(0xFF1890FF),
        ),
      ),
    );
  }

  Widget _buildSubInfo({
    required IconData icon,
    required String text,
    // TODO refactor
    bool isTextExpanded = false,
  }) {
    final textWidget = Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Color(0xFFA5A5A5),
        fontSize: 12,
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Color(0xFFA5A5A5),
          size: 18,
        ),
        SizedBox(width: AppDimens.paddingTiny),
        isTextExpanded
            ? Expanded(
                child: textWidget,
              )
            : textWidget,
      ],
    );
  }
}
