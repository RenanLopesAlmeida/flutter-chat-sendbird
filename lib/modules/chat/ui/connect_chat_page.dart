import 'package:chat/modules/chat/ui/chat_page.dart';
import 'package:flutter/material.dart';

import 'package:sendbird_sdk/sendbird_sdk.dart' as SendBird;

//const USER_ID = 'UID123456789';

class ConnectChatPage extends StatelessWidget {
  final SendBird.SendbirdSdk sendBird = SendBird.SendbirdSdk(
    appId: '06BE9940-60F0-4BD6-A302-992C7B524805',
  );

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
    String nickname = 'Aluno';

    return sendBird.connect(USER_ID, nickname: nickname);
  }

  Future<SendBird.GroupChannel?> _createGroupChannel(
      SendBird.User sendBirdUser) async {
    var adminID = '844761';

    final groupParams = SendBird.GroupChannelParams()
      ..userIds = [USER_ID, adminID]

      //..operatorUserIds = [adminID]
      ..name = 'ChattV05'
      ..isDistinct = true;

    return await SendBird.GroupChannel.createChannel(groupParams);
  }
}

const USER_ID = '1234568910';
