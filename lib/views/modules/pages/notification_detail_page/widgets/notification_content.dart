part of '../notification_detail_page.dart';

class _NotificationContent extends StatelessWidget {
  final NotificationAppDto notification;
  final double containerWidth;

  const _NotificationContent({
    Key? key,
    required this.notification,
    required this.containerWidth,
  }) : super(key: key);

  String _formatDateTime(DateTime dateTimeUTC, String langCode) {
    final DateTime dateTime = dateTimeUTC.toLocal();
    if (langCode == "ja") {
      return "${dateTime.year}年${dateTime.month}月${dateTime.day}日\n${dateTime.hour}時${dateTime.minute}分";
    }
    return "${dateTime.year}/${dateTime.month}/${dateTime.day}\n${dateTime.hour}:${dateTime.minute}";
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppSemantics(
                    labelList: [
                      _formatDateTime(
                        notification.lastPushAt,
                        notification.getLang(),
                      )
                    ],
                    child: Text(
                      _formatDateTime(
                        notification.lastPushAt,
                        notification.getLang(),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (notification.company != null) ...{
                    AppSemantics(
                      labelList: [notification.company!.companyName],
                      child: Container(
                        width: 100,
                        child: Text(
                          notification.company!.companyName,
                          maxLines: 3,
                        ),
                      ),
                    )
                  },
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: AppSemantics(
                labelList: [notification.getTitle()],
                child: Text(
                  notification.getTitle(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
            notification.qrCode != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      notification.qrCode!.link,
                      height: 150,
                    ),
                  )
                : Container(),
            _buildThumbnail(notification),
            _buildUrlText(notification),
            _buildContentBox(
              child: AppSemantics(
                labelList: [notification.getContent()],
                child: Text(
                  notification.getContent(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(NotificationAppDto notification) {
    final foundPictureAttachment =
        notification.attachmentList?.firstWhereOrNull(
      (attachment) => attachment.type == AttachmentType.picture,
    );

    if (foundPictureAttachment == null) {
      return SizedBox();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppDimens.paddingMedium),
      constraints: BoxConstraints(maxWidth: containerWidth * 7 / 10),
      child: AppNetworkImage(
        imageUrl: foundPictureAttachment.url,
        defaultImageAsset: AppAssets.notificationDefault,
      ),
    );
  }

  Widget _buildUrlText(NotificationAppDto notification) {
    final foundUrlAttachment = notification.attachmentList?.firstWhereOrNull(
      (attachment) => attachment.type == AttachmentType.url,
    );
    final foundPdfAttachment = notification.attachmentList?.firstWhereOrNull(
      (attachment) => attachment.type == AttachmentType.pdf,
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          if (foundUrlAttachment != null) ...{
            Row(
              children: [
                _buildAttachmentIcon(foundUrlAttachment.type.getIconData()),
                InkWell(
                  onTap: () async {
                    if (await canLaunch(foundUrlAttachment.url)) {
                      await launch(foundUrlAttachment.url);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      notification.getLang() == "ja"
                          ? "詳細はこちら"
                          : "More Details",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                )
              ],
            )
          },
          if (foundPdfAttachment != null) ...{
            Row(
              children: [
                _buildAttachmentIcon(foundPdfAttachment.type.getIconData()),
                Flexible(
                  child: InkWell(
                    onTap: () async {
                      await launch(foundPdfAttachment.url);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        foundPdfAttachment.url.split("/").last,
                        maxLines: 2,
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                )
              ],
            )
          }
        ],
      ),
    );
  }

  Widget _buildAttachmentIcon(IconData icon) {
    return Container(
      width: 20,
      height: 20,
      margin: EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        border: Border.all(
          color: Color(0xFFA5A5A5),
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 16,
          color: Color(0xFF1890FF),
        ),
      ),
    );
  }

  Widget _buildContentBox({required Widget child}) {
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
}
