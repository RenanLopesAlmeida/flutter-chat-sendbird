part of '../chat_page.dart';

class _ChatBubbleMessage extends StatelessWidget {
  const _ChatBubbleMessage({
    this.isMyMessage = false,
    this.isMessageSeen = false,
    this.messageId,
    this.imageUrl,
    required this.messageTimestamp,
    required this.message,
  });

  final bool isMyMessage;
  final String message;
  final int? messageId;
  final int messageTimestamp;
  final bool isMessageSeen;
  final String? imageUrl;

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
        : Colors.black87; //_colorScheme.onBackground.withOpacity(0.88);

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
          flex: 2,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bubbleMessageWidth = constraints.maxWidth;
              final image = imageUrl;

              if (image == null) {
                return _renderBubbleMessageText(
                  alignment: _alignment,
                  bubbleMessageBackgroundColor: bubbleMessageBackgroundColor,
                  bubbleMessageTextColor: bubbleMessageTextColor,
                  textTheme: _textTheme,
                );
              }
              return _renderBubbleMessageImage(
                context: context,
                alignment: _alignment,
                bubbleMessageBackgroundColor: bubbleMessageBackgroundColor,
                bubbleMessageTextColor: bubbleMessageTextColor,
                textTheme: _textTheme,
                imageUrl: image,
                size: Size(bubbleMessageWidth, bubbleMessageWidth),
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

  Widget _renderBubbleMessageText(
      {required AlignmentGeometry alignment,
      required Color bubbleMessageBackgroundColor,
      required Color bubbleMessageTextColor,
      required TextTheme textTheme}) {
    return Container(
      //width: bubbleMessageWidth,
      alignment: alignment,
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
          style: textTheme.caption?.copyWith(
            color: bubbleMessageTextColor,
          ),
        ),
      ),
    );
  }

  Widget _renderBubbleMessageImage(
      {required AlignmentGeometry alignment,
      required Color bubbleMessageBackgroundColor,
      required Color bubbleMessageTextColor,
      required TextTheme textTheme,
      required String imageUrl,
      required Size size,
      required BuildContext context}) {
    return InkWell(
      onTap: () {
        _renderDialog(context, imageUrl);
      },
      child: Container(
        constraints:
            BoxConstraints(minWidth: size.width, minHeight: size.height),
        alignment: alignment,
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
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Text('😢');
            },
          ),
        ),
      ),
    );
  }

  _renderDialog(BuildContext context, String imageUrl) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black12.withOpacity(0.6), // Background color
      barrierDismissible: false,
      barrierLabel: 'Dialog',
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return SizedBox.expand(
          child: ZoomOverlay(
            minScale: 1,
            maxScale: 7,
            twoTouchOnly: true,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: SizedBox.expand(
                    child: Image.network(imageUrl, fit: BoxFit.contain),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox.expand(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Fechar',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
