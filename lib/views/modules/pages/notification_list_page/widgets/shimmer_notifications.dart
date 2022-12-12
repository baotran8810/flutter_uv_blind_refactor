part of '../notification_list_page.dart';

class _ShimmerListView extends StatelessWidget {
  const _ShimmerListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        itemCount: 10,
        separatorBuilder: (_, __) {
          return Divider(
            height: 1,
            thickness: 1,
          );
        },
        itemBuilder: (_, __) {
          return _buildFakeItem();
        },
      ),
    );
  }

  Widget _buildFakeItem() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.paddingNormal,
        vertical: AppDimens.paddingNormal,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 68,
            height: 68,
            color: Colors.white,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFakeItemText('aaaaaaaaaaaaaaaaaaaa'),
                SizedBox(height: 8),
                _buildFakeItemText('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'),
                SizedBox(height: 8),
                _buildFakeItemText('aaaaaaaaaaaaaaaaaaaaaaaaa'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFakeItemText(String text) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
        ),
      ),
    );
  }
}
