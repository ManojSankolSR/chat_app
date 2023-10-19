import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatMessages extends StatelessWidget {
  ChatMessages({super.key});
  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No Messages Found'),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something Went Wrong..!'),
          );
        }
        final loadedMessages = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 40,
            right: 13,
            left: 13,
          ),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (context, index) {
            final ChatMessages = loadedMessages[index].data();
            final nextChatMessage = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data()
                : null;
            final currentMessageUserId = ChatMessages['userId'];
            final nextChatMesssageUserId =
                nextChatMessage != null ? nextChatMessage['userId'] : null;
            final nextUserIsSame =
                nextChatMesssageUserId == currentMessageUserId;

            if (nextUserIsSame) {
              return MessageBubble.next(
                  message: ChatMessages['text'],
                  isMe: authenticatedUser.uid == currentMessageUserId);
            }
            if (!nextUserIsSame) {
              return MessageBubble.first(
                  userImage: ChatMessages['userImage'],
                  username: ChatMessages['username'],
                  message: ChatMessages['text'],
                  isMe: authenticatedUser.uid == currentMessageUserId);
            }
          },
        );
      },
    );
  }
}
