import 'package:chat/modules/chat/ui/chat_page.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';

import 'package:sendbird_sdk/sendbird_sdk.dart' as SendBird;

//const USER_ID = 'UID123456789';

class ConnectChatPage extends StatelessWidget {
  final SendBird.SendbirdSdk sendBird =
      SendBird.SendbirdSdk(appId: 'B153AFC0-DDE8-4AC4-BBCA-6EB97CF4CE6B');

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
      ),
    );
  }

  Future<SendBird.User> _connectToSendBirdServer() async {
    String userID = '';
    String nickname = '';

    if (kReleaseMode) {
      userID = 'UID123456789';
      nickname = 'Aluno';
    } else {
      userID = '123456';
      nickname = 'professor';
    }

    return sendBird.connect(userID, nickname: nickname);
  }

  Future<SendBird.GroupChannel?> _createGroupChannel(
      SendBird.User sendBirdUser) async {
    String userID = '';

    if (kReleaseMode) {
      userID = 'UID123456789';
    } else {
      userID = '123456';
    }
    var adminID = '271297';

    final groupParams = SendBird.GroupChannelParams()
      ..userIds = [userID, adminID]

      //..operatorUserIds = [adminID]
      ..name = 'ChatV01'
      ..isDistinct = true;

    return await SendBird.GroupChannel.createChannel(groupParams);
  }
}
