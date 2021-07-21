import 'package:chat/modules/chat/ui/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:sendbird_sdk/sendbird_sdk.dart' as SendBird;

const USER_ID = 'UID123456789';

class ConnectChatPage extends StatelessWidget {
  final SendBird.SendbirdSdk sendBird =
      SendBird.SendbirdSdk(appId: 'B153AFC0-DDE8-4AC4-BBCA-6EB97CF4CE6B');

  final BehaviorSubject<SendBird.GroupChannel?> _channel =
      BehaviorSubject.seeded(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('connect'),
          onPressed: () async {
            try {
              final sendBirdUser = await _connectToSendBirdServer();

              final channel = await _createGroupChannel(sendBirdUser);
              if (channel == null) {
                return;
              }

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatPage(channel: channel),
                  ));
              //_channel.add(channel);
            } catch (error, stackStrace) {
              print('Error. $error | Stacktrace: $stackStrace');
            }
          },
        ),

        // ElevatedButton(
        //   child: Text('Send Message'),
        //   onPressed: () async {
        //     try {
        //       _channel.map((channel) {
        //         if (channel == null) {
        //           return;
        //         }

        //         _sendMessage(channel);
        //       }).listen((_) {});
        //     } catch (error, stackStrace) {
        //       print('Error. $error | Stacktrace: $stackStrace');
        //     }
        //   },
        // ),
      ),
    );
  }

  Future<SendBird.User> _connectToSendBirdServer() async =>
      await sendBird.connect(USER_ID, nickname: 'Renan');

  Future<SendBird.GroupChannel?> _createGroupChannel(
      SendBird.User sendBirdUser) async {
    var adminID = '271297';

    final groupParams = SendBird.GroupChannelParams()
      ..userIds = [USER_ID, adminID]
      ..operatorUserIds = [adminID]
      ..name = 'ChatV01'
      ..isDistinct = true;

    return await SendBird.GroupChannel.createChannel(groupParams);
  }

  void _sendMessage(SendBird.GroupChannel channel) {
    final params =
        SendBird.UserMessageParams(message: 'Mensagem do aluno teste4');

    channel.sendUserMessage(
      params,
      onCompleted: (message, error) {
        print(message);
      },
    );
  }

  Stream<List<SendBird.BaseMessage>> _loadPastMessages(
      SendBird.GroupChannel channel) {
    final result = SendBird.PreviousMessageListQuery(
        channelUrl: channel.channelUrl, channelType: channel.channelType);

    return result.loadNext().asStream();
  }
}
