import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import 'package:sendbird_sdk/sendbird_sdk.dart' as SendBird;
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';

part './components/appbar_doubt_chat.dart';
part './components/chat_message_sender.dart';
part './components/chat_bubble_message.dart';
part './components/chat_message_delivered_info.dart';

class ChatPage extends StatelessWidget with SendBird.ChannelEventHandler {
  ChatPage({required this.channel}) {
    SendBird.SendbirdSdk().addChannelEventHandler(channel.channelUrl, this);

    _loadPastMessages(channel).listen((baseMessages) {
      _baseMessages.add(baseMessages);

      final bubbleMessages = _messages?.value;
      baseMessages.forEach((baseMessage) {
        if (baseMessage is SendBird.FileMessage) {
          bubbleMessages?.add(
            _ChatBubbleMessage(
              message: baseMessage.message,
              isMyMessage: baseMessage.sender?.isCurrentUser ?? false,
              messageId: baseMessage.messageId,
              messageTimestamp: baseMessage.createdAt,
              imageUrl: baseMessage.secureUrl,
            ),
          );
        } else {
          bubbleMessages?.add(
            _ChatBubbleMessage(
              message: baseMessage.message,
              isMyMessage: baseMessage.sender?.isCurrentUser ?? false,
              messageId: baseMessage.messageId,
              messageTimestamp: baseMessage.createdAt,
            ),
          );
        }

        if (bubbleMessages == null) {
          return;
        }

        _messages?.add(bubbleMessages);
        _scrollToTheBottom();
      });

      channel.markAsRead();
    });
  }

  final BehaviorSubject<String?> _message = BehaviorSubject.seeded(null);
  final BehaviorSubject<List<_ChatBubbleMessage>>? _messages =
      BehaviorSubject.seeded([]);

  final BehaviorSubject<List<SendBird.BaseMessage>> _baseMessages =
      BehaviorSubject.seeded([]);

  final SendBird.GroupChannel channel;

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEFF3FC),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: _AppBarDoubtChat(handlePickImage: _handlePickImage),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 8,
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<_ChatBubbleMessage>>(
                stream: _messages,
                builder: (context, snapshot) {
                  final messages = snapshot.data;

                  return (messages == null)
                      ? const SizedBox()
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];

                            return message;
                          },
                        );
                },
              ),
            ),
            _ChatMessageSender(
              onChanged: _onChangeText,
              onPressed: _onPressed,
            ),
          ],
        ),
      ),
    );
  }

  void _onChangeText(String text) {
    _message.add(text);
  }

  void _onPressed() {
    final message = _message.value;
    if (message == null) {
      return;
    }

    _sendMessage(channel, message);

    //_scrollToTheBottom();
  }

  void _sendMessage(SendBird.GroupChannel channel, String message) {
    final params = SendBird.UserMessageParams(message: message);

    final preMessage = channel.sendUserMessage(
      params,
    );

    List<_ChatBubbleMessage> bubbleMessages = _messages?.value ?? [];

    bubbleMessages.add(_ChatBubbleMessage(
      message: message,
      messageId: preMessage.messageId,
      isMyMessage: true,
      messageTimestamp: preMessage.createdAt,
    ));

    _messages?.add(bubbleMessages);

    if (preMessage.sendingStatus == SendBird.MessageSendingStatus.failed) {
      //TODO: remove it from message list
    }
  }

  Stream<List<SendBird.BaseMessage>> _loadPastMessages(
      SendBird.GroupChannel channel) {
    final result = SendBird.PreviousMessageListQuery(
        channelUrl: channel.channelUrl, channelType: channel.channelType);

    return result.loadNext().asStream();
  }

  @override
  onMessageReceived(channel, baseMessage) {
    final message = baseMessage.message;
    List<_ChatBubbleMessage> bubbleMessages = _messages?.value ?? [];

    if (baseMessage is SendBird.FileMessage) {
      bubbleMessages.add(_ChatBubbleMessage(
        message: message,
        messageId: baseMessage.messageId,
        messageTimestamp: baseMessage.createdAt,
        imageUrl: baseMessage.url,
      ));
    } else {
      bubbleMessages.add(_ChatBubbleMessage(
        message: message,
        messageId: baseMessage.messageId,
        messageTimestamp: baseMessage.createdAt,
      ));
    }

    _messages?.add(bubbleMessages);
    _scrollToTheBottom();

    if (channel is SendBird.GroupChannel) {
      channel.markAsRead();
      final readMembers = channel.getReadMembers(_baseMessages.value.first);
      final a = 0;
    }
  }

  @override
  void onMessageDeleted(SendBird.BaseChannel channel, int messageId) {
    super.onMessageDeleted(channel, messageId);

    _baseMessages.flatMap((messages) {
      return Stream.value(
          messages.removeWhere((message) => message.messageId == messageId));
    }).listen((_) {});
  }

  @override
  void onReadReceiptUpdated(SendBird.GroupChannel channel) {
    //super.onReadReceiptUpdated(channel);

    final lastMessage = channel.lastMessage;
    if (lastMessage == null) {
      return;
    }

    final readMembers = channel.getReadMembers(lastMessage);

    readMembers.first.lastSeenAt;
  }

  void _scrollToTheBottom() {
    _scrollController.animateTo(_scrollController.position.viewportDimension,
        duration: Duration(milliseconds: 400), curve: Curves.linear);
  }

  Future<void> _handlePickImage(int index) async {
    final ImagePicker _picker = ImagePicker();

    switch (index) {
      case 0:
        final XFile? image =
            await _picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          _sendFileMessage(image);
        }
        break;
    }
  }

  _sendFileMessage(XFile image) {
    // final params = SendBird.FileMessageParams.withFile(image);

    // final preMessage = await channel.sendFileMessage()
  }
}
