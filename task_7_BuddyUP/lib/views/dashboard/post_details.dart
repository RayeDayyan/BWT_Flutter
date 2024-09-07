import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_7_buddyup/controllers/providers/creator_id_provider.dart';
import 'package:task_7_buddyup/controllers/providers/current_post_provider.dart';
import 'package:task_7_buddyup/controllers/providers/get_all_posts_provider.dart';
import 'package:task_7_buddyup/controllers/providers/search_results_provider.dart';
import 'package:task_7_buddyup/controllers/services/post_controller.dart';
import 'package:task_7_buddyup/models/post_model.dart';
import 'package:task_7_buddyup/views/messaging/chat.dart';
import 'package:task_7_buddyup/views/widgets/bottom_nav.dart';
import 'package:task_7_buddyup/views/widgets/custom_app_bar.dart';

class PostDetails extends ConsumerStatefulWidget {
  @override
  ConsumerState<PostDetails> createState() => PostDetailsState();
}

class PostDetailsState extends ConsumerState<PostDetails> {
  final auth = FirebaseAuth.instance;

  final _postController = PostController();

  String? _address;

  late LatLng location;

  void setAddress(LatLng coordinates) async {
    final placeMark = await placemarkFromCoordinates(
        coordinates.latitude, coordinates.longitude);

    setState(() {
      _address = placeMark.first.name;
    });
  }

  int participants = 0;

  @override
  Widget build(BuildContext context) {
    Post? post = ref.watch(currentPost);

    location = LatLng(post!.location['lat']!, post.location['lng']!);

    setAddress(location);

    participants = post.currentParticipants;

    String uid = auth.currentUser!.uid;

    return Scaffold(
      appBar: CustomAppBar(),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Container(
              width: 100.w, height: 20.h, child: Image.network(post.image)),
          SizedBox(
            height: 2.h,
          ),
          SizedBox(
            height: 2.h,
          ),
          SizedBox(
            height: 1.h,
          ),
          Text(
            'Title',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 18.sp),
          ),
          Text(
            '${post.title}',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 16.sp),
          ),
          Text(
            'Activity Type',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 18.sp),
          ),
          Text(
            '${post.type}',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 16.sp),
          ),
          Text(
            'Date',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 18.sp),
          ),
          Text(
            '${post.date}',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16.sp,
                decoration: TextDecoration.underline),
          ),
          Text(
            'Time',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 18.sp),
          ),
          Text(
            '${post.time}',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16.sp,
                decoration: TextDecoration.underline),
          ),
          Container(
            height: 25.h,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: location, zoom: 10),
              markers: {
                Marker(markerId: MarkerId('location'), position: location)
              },
            ),
          ),
          Text(
            '$_address',
            style: TextStyle(fontSize: 18.sp, fontFamily: 'Poppins'),
          ),
          Text(
            'Maximum Participants',
            style: TextStyle(fontSize: 18.sp, fontFamily: 'Poppins'),
          ),
          Text(
            '${post.maxParticipants}',
            style: TextStyle(fontSize: 16.sp, fontFamily: 'Poppins'),
          ),
          Text(
            'Current Participants',
            style: TextStyle(fontSize: 18.sp, fontFamily: 'Poppins'),
          ),
          Row(
            children: [
              Text(
                '${post.currentParticipants}',
                style: TextStyle(fontSize: 16.sp, fontFamily: 'Poppins'),
              ),
              post.creatorID == uid
                  ? Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              if (post.currentParticipants <
                                  post.maxParticipants) {
                                participants += 1;

                                Post post1 = Post(
                                    postID: post.postID,
                                    title: post.title,
                                    type: post.type,
                                    date: post.date,
                                    time: post.time,
                                    maxParticipants: post.maxParticipants,
                                    requirements: post.requirements,
                                    description: post.description,
                                    image: post.image,
                                    creatorID: post.creatorID,
                                    currentParticipants: participants,
                                    location: post.location);

                                await _postController.setMembers(
                                    participants, post.postID!);

                                ref.refresh(getAllPostsProvider);
                                ref.refresh(searchResultsProvider);

                                ref.read(currentPost.state).state = post1;
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        content: Center(
                                  child: Text('Maximum members reached'),
                                )));
                              }
                            },
                            icon: const Icon(
                              Icons.add,
                            )),
                        SizedBox(
                          width: 1.w,
                        ),
                        IconButton(
                            onPressed: () async {
                              if (post.currentParticipants > 0) {
                                participants -= 1;

                                Post post1 = Post(
                                    postID: post.postID,
                                    title: post.title,
                                    type: post.type,
                                    date: post.date,
                                    time: post.time,
                                    maxParticipants: post.maxParticipants,
                                    requirements: post.requirements,
                                    description: post.description,
                                    image: post.image,
                                    creatorID: post.creatorID,
                                    currentParticipants: participants,
                                    location: post.location);

                                await _postController.setMembers(
                                    participants, post.postID!);

                                ref.refresh(getAllPostsProvider);
                                ref.refresh(searchResultsProvider);

                                ref.read(currentPost.state).state = post1;
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        content: Center(
                                  child: Text('Can not go lower than zero'),
                                )));
                              }
                            },
                            icon: Icon(
                              Icons.minimize,
                            ))
                      ],
                    )
                  : SizedBox(
                      width: 2.w,
                    ),
            ],
          ),
          Text(
            'Requirements',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 18.sp),
          ),
          Text(
            '${post.requirements}',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 16.sp),
          ),
          Text(
            'Description',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 18.sp),
          ),
          Text(
            '${post.description}',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 16.sp),
          ),
          SizedBox(
            height: 2.h,
          ),
          uid != post.creatorID
              ? Container(
                  width: 85.w,
                  height: 6.5.h,
                  child: ElevatedButton(
                      onPressed: () {
                        final uid = auth.currentUser!.uid;

                        if (uid != post.creatorID &&
                            post.maxParticipants != post.currentParticipants) {
                          ref.read(creatorID.state).state = post.creatorID;
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Chat()));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF31473A),
                      ),
                      child: Text(
                        post.maxParticipants != post.currentParticipants
                            ? 'Message Organizer'
                            : 'Max slots reached',
                        style: TextStyle(
                          fontFamily: 'Poppins-Light',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Color(0XFFEDF4F2),
                        ),
                      )))
              : SizedBox(
                  height: 2.h,
                ),
          SizedBox(
            height: 2.h,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
