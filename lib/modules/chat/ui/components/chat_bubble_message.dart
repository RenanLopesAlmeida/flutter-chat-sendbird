part of '../chat_page.dart';

class _ChatBubbleMessage extends StatelessWidget {
  const _ChatBubbleMessage({
    this.isMyMessage = false,
    this.isMessageSeen = false,
    this.messageId,
    required this.messageTimestamp,
    required this.message,
  });

  final bool isMyMessage;
  final String message;
  final int? messageId;
  final int messageTimestamp;
  final bool isMessageSeen;

  @override
  Widget build(BuildContext context) {
    final _colorScheme = Theme.of(context).colorScheme;
    final _textTheme = Theme.of(context).textTheme;
    final _alignment =
        (isMyMessage) ? Alignment.centerRight : Alignment.centerLeft;

    final bubbleMessageBackgroundColor =
        (isMyMessage) ? _colorScheme.primary : _colorScheme.surface;
    final bubbleMessageTextColor = (isMyMessage)
        ? _colorScheme.surface.withOpacity(0.88)
        : Colors.green; //_colorScheme.onBackground.withOpacity(0.88);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (isMyMessage)
          Expanded(
            flex: 4,
            child: _ChatMessageDeliveredInfo(
              alignment: _alignment,
              showSeenMessageIcon: isMyMessage,
              messageTimestamp: messageTimestamp,
            ),
          ),
        if (!isMyMessage)
          Container(
            height: 28,
            width: 28,
            margin: EdgeInsets.only(right: 8, bottom: 16),
          ),
        Expanded(
          flex: 3,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bubbleMessageWidth = constraints.maxWidth;

              return Container(
                width: bubbleMessageWidth,
                alignment: _alignment,
                child: Container(
                  //width: bubbleMessageSize,
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  margin: EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: bubbleMessageBackgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    message,
                    style: _textTheme.caption?.copyWith(
                      color: bubbleMessageTextColor,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (!isMyMessage)
          Expanded(
            flex: 4,
            child: _ChatMessageDeliveredInfo(
              alignment: _alignment,
              showSeenMessageIcon: isMyMessage,
              messageTimestamp: messageTimestamp,
            ),
          ),
      ],
    );
  }
}
