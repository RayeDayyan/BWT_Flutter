import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_7_buddyup/controllers/providers/creator_provider.dart';
import 'package:task_7_buddyup/controllers/providers/chat_ID_provider.dart';
import 'package:task_7_buddyup/controllers/providers/get_chats_provider.dart';
import 'package:task_7_buddyup/controllers/services/message_controller.dart';
import 'package:task_7_buddyup/models/message_model.dart';

class Chat extends ConsumerStatefulWidget {
  @override
  ConsumerState<Chat> createState() => ChatState();
}

class ChatState extends ConsumerState<Chat> {
  TextEditingController messageController = TextEditingController();
  final _controller = MessageController();
  String? chatID;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return ref.watch(creatorProvider).when(data: (user) {
      String? profile = user?.Profile;
      return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
              backgroundColor: Color(0xFF31473A),
              centerTitle: true,
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        user!.Profile != null ? NetworkImage(profile!) : null,
                    radius: 6.5.w,
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  Text(user.Name,
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20.sp,
                          letterSpacing: 3,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ],
              )),
          body: ref.watch(chatIDProvider(user.UserID)).when(data: (chatRoomID) {
            chatID = chatRoomID;
            return ref.watch(getChatsProvider(chatID!)).when(data: (messages) {
              final uid = auth.currentUser!.uid;
              return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isOurMessage = uid == message.senderID;
                    return ListTile(
                        title: Align(
                      alignment: isOurMessage
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.w),
                            color: isOurMessage
                                ? Color(0xFF31473A)
                                : Color(0XFF87ab96),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                message.content,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontFamily: 'Poppins',
                                ),
                                maxLines: null,
                                overflow: TextOverflow.visible,
                              )
                            ],
                          )),
                    ));
                  });
            }, error: (error, stackTree) {
              return const Text('error occured while fetching messages');
            }, loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            });
          }, error: (error, stackTree) {
            return Text('$error');
          }, loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: 8.h,
              decoration: const BoxDecoration(
                color: Color(0xFF31473A),
              ),
              child: Row(
                children: [
                  SizedBox(width: 2.w),
                  Expanded(
                    child: TextField(
                      minLines: 1,
                      maxLines: null,
                      style: const TextStyle(fontFamily: 'Poppins'),
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: 'Send a message',
                        hintStyle: const TextStyle(fontFamily: 'Poppins'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.w),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      String uid = auth.currentUser!.uid;

                      Message message = Message(
                          senderID: uid,
                          content: messageController.text.toString(),
                          timeStamp: DateTime.now());

                      bool result =
                          await _controller.addMessage(chatID!, message);

                      if (result == true) {
                        messageController.clear();
                      }
                    },
                    icon: Icon(Icons.send, color: Colors.white),
                  ),
                ],
              ),
            ),
          ));
    }, error: (error, stackTree) {
      return const Scaffold(
        body: Text('Error occured'),
      );
    }, loading: () {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }
}
