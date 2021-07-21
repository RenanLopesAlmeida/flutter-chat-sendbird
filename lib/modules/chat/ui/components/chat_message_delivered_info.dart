part of '../chat_page.dart';

class _ChatMessageDeliveredInfo extends StatelessWidget {
  const _ChatMessageDeliveredInfo({
    required this.alignment,
    this.showSeenMessageIcon = true,
    required this.messageTimestamp,
  });

  final Alignment alignment;
  final bool showSeenMessageIcon;
  final int messageTimestamp;

  @override
  Widget build(BuildContext context) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(messageTimestamp);
    final formattedMessageTime = DateFormat('dd-MM/kk:mm').format(date);

    return Container(
      margin: EdgeInsets.only(
        right: 2,
        left: 2,
        bottom: 16,
      ),
      alignment: alignment,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (showSeenMessageIcon) Icon(Icons.done),
          Container(
            margin: EdgeInsets.only(
              top: 3,
              right: 4,
            ),
            child: Text(
              formattedMessageTime,
              style: Theme.of(context).textTheme.overline?.copyWith(
                    color: Colors.black38,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
