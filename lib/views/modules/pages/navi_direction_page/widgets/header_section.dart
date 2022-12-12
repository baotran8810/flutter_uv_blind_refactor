part of '../navi_direction_page.dart';

class _HeadingSection extends StatelessWidget {
  final String titleText;
  final void Function() onPressedToggleRevert;
  final void Function() onPressedBack;

  const _HeadingSection({
    Key? key,
    required this.titleText,
    required this.onPressedToggleRevert,
    required this.onPressedBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 37,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFA5A5A5),
          ),
        ),
      ),
      child: Column(
        children: [
          AppSemantics(
            labelList: [titleText],
            child: Text(
              titleText,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _buildActionBtn(
                  onPresed: () {
                    onPressedToggleRevert();
                  },
                  color: Color(0xFF00689D),
                  text: tra(LocaleKeys.btn_reverseCourse),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: _buildActionBtn(
                  onPresed: () {
                    onPressedBack();
                  },
                  color: Color(0xFFA21942),
                  text: tra(LocaleKeys.btn_backToMenu),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn({
    required Color color,
    required String text,
    required void Function() onPresed,
  }) {
    return AppButtonNew(
      semanticLabel: text,
      height: 46,
      borderRadius: BorderRadius.circular(2),
      btnColor: color,
      onPressed: () {
        onPresed();
      },
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    );
  }
}
