part of '../chat_page.dart';

class _ChatMessageSender extends StatelessWidget {
  _ChatMessageSender({required this.onChanged, required this.onPressed});

  final TextEditingController _messageController = TextEditingController();

  final Function(String text) onChanged;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    final _colorScheme = Theme.of(context).colorScheme;
    final _textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: _colorScheme.surface,
            ),
            child: TextField(
              controller: _messageController,
              onChanged: onChanged,
              style: _textTheme.caption,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(
                  16,
                  0,
                  8,
                  8,
                ),
                hintText: 'Digite uma mensagem',
                hintStyle:
                    _textTheme.bodyText2?.copyWith(color: Color(0xff858585)),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            _messageController.clear();
            onPressed.call();
          },
          child: Container(
              height: 32,
              width: 32,
              margin: EdgeInsets.only(
                left: 8,
                right: 16,
              ),
              decoration: BoxDecoration(
                color: Color(0xff909090),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.send)),
        )
      ],
    );
  }
}
