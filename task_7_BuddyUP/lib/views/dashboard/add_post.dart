import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_7_buddyup/controllers/providers/creator_provider.dart';
import 'package:task_7_buddyup/controllers/providers/get_all_posts_provider.dart';
import 'package:task_7_buddyup/controllers/services/post_controller.dart';
import 'package:task_7_buddyup/models/post_model.dart';
import 'package:task_7_buddyup/views/dashboard/home_page.dart';
import 'package:task_7_buddyup/views/widgets/bottom_nav.dart';
import 'package:task_7_buddyup/views/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';

class AddPost extends ConsumerStatefulWidget {
  @override
  ConsumerState<AddPost> createState() => AddPostState();
}

class AddPostState extends ConsumerState<AddPost> {
  final activitiesList = ['Hike', 'Trip', 'Cycling'];
  String? formattedDate;
  String? formattedTime;

  final auth = FirebaseAuth.instance;

  TextEditingController titleController = TextEditingController();
  TextEditingController maxController = TextEditingController();
  TextEditingController requirementsController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController currentController = TextEditingController();

  String? selectedActivity;

  XFile? image;

  String? address;

  LatLng coordinates = LatLng(33.6995, 73.0363);

  void _onCameraMove(CameraPosition position) {
    setState(() {
      coordinates = position.target;
    });

    setAddress(coordinates);
  }

  @override
  void initState() {
    super.initState();
  }

  void setAddress(LatLng coordinates) async {
    try {
      final placemarks = await placemarkFromCoordinates(
          coordinates.latitude, coordinates.longitude);

      setState(() {
        address = placemarks.first.name;
      });
    } catch (e) {
      address = 'error occured $e';
      print('error $e');
    }
  }

  void pickImage() async {
    final imagePicker = ImagePicker();
    XFile? selectedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      setState(() {
        image = selectedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    setAddress(coordinates);

    return Scaffold(
      appBar: CustomAppBar(),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Container(
            width: 100.w,
            height: 20.h,
            child: GestureDetector(
              onTap: pickImage,
              child: image == null
                  ? Icon(
                      Icons.camera_alt,
                      size: 20.h,
                    )
                  : Image.file(File(image!.path)),
            ),
          ),
          Text(
            'Title',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 18.sp),
          ),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(fontSize: 14.sp, fontFamily: 'Poppins'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                )),
          ),
          Text(
            'Activity Type',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 18.sp),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1)),
            width: 100.w,
            child: DropdownButton(
                isExpanded: true,
                value: selectedActivity,
                hint: Text(
                  'Activity',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14.sp,
                  ),
                ),
                items: activitiesList.map((item) {
                  return DropdownMenuItem(
                    child: Text(item),
                    value: item,
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedActivity = val;
                  });
                }),
          ),
          Row(
            children: [
              Text(
                'Select Date',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 18.sp),
              ),
              SizedBox(
                width: 10.w,
              ),
              IconButton(
                  onPressed: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2050),
                    );

                    formattedDate = DateFormat.yMd().format(selectedDate!);

                    if (formattedDate != null) {
                      setState(() {});
                    }
                  },
                  icon: Icon(Icons.edit))
            ],
          ),
          Text(
            formattedDate != null ? formattedDate.toString() : 'Date',
            style: TextStyle(
              fontSize: 16.sp,
            ),
          ),
          Row(
            children: [
              Text(
                'Select Time',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 18.sp),
              ),
              SizedBox(
                width: 10.w,
              ),
              IconButton(
                  onPressed: () async {
                    TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        initialEntryMode: TimePickerEntryMode.input);

                    if (selectedTime != null) {
                      var help1 = DateTime.now();
                      var help = DateTime(help1.year, help1.month, help1.day,
                          selectedTime.hour, selectedTime.minute);

                      formattedTime = DateFormat.jm().format(help);
                      setState(() {});
                    }
                  },
                  icon: Icon(Icons.edit))
            ],
          ),
          Text(
            formattedTime != null ? formattedTime.toString() : 'Time',
            style: TextStyle(
              fontSize: 16.sp,
            ),
          ),
          Text(
            'Location',
            style: TextStyle(fontSize: 18.sp, fontFamily: 'Poppins'),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            height: 25.h,
            child: GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: coordinates, zoom: 10),
              markers: {
                Marker(markerId: MarkerId('test'), position: coordinates)
              },
              onCameraMove: _onCameraMove,
            ),
          ),
          Text(
            '$address',
            style: TextStyle(fontSize: 18.sp, fontFamily: 'Poppins'),
          ),
          Text(
            'Maximum Participants',
            style: TextStyle(fontSize: 18.sp, fontFamily: 'Poppins'),
          ),
          TextField(
            controller: maxController,
            decoration: InputDecoration(
                hintText: 'Max. Participants',
                hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 14.sp),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)))),
          ),
          Text(
            'Current Participants',
            style: TextStyle(fontSize: 18.sp, fontFamily: 'Poppins'),
          ),
          TextField(
            controller: currentController,
            decoration: InputDecoration(
                hintText: 'Current Participants',
                hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 14.sp),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)))),
          ),
          Text(
            'Requirements',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 18.sp),
          ),
          TextField(
            controller: requirementsController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText:
                  'Describe activity requirements like tools, skill levels etc. ',
              hintStyle: TextStyle(fontSize: 14.sp, fontFamily: 'Poppins'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          Text(
            'Description',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 18.sp),
          ),
          TextField(
            controller: descriptionController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Explain your plan to everyone !',
              hintStyle: TextStyle(fontSize: 14.sp, fontFamily: 'Poppins'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Container(
            width: 85.w,
            height: 6.5.h,
            child: ElevatedButton(
              onPressed: () async {
                if (image != null &&
                    titleController.text.isNotEmpty &&
                    selectedActivity != null &&
                    formattedDate != null &&
                    formattedTime != null &&
                    maxController.text.isNotEmpty &&
                    requirementsController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty &&
                    currentController.text.isNotEmpty) {
                  final controller1 = PostController();

                  String? imageUrl = await controller1.uploadImage(image!);

                  var uid = auth.currentUser?.uid;

                  Map<String, double> location = {
                    'lat': coordinates.latitude,
                    'lng': coordinates.longitude
                  };

                  final post = Post(
                      title: titleController.text.toString(),
                      type: selectedActivity!,
                      date: formattedDate!,
                      time: formattedTime!,
                      maxParticipants: int.parse(maxController.text.toString()),
                      requirements: requirementsController.text.toString(),
                      description: descriptionController.text.toString(),
                      image: imageUrl!,
                      creatorID: uid!,
                      currentParticipants:
                          int.parse(currentController.text.toString()),
                      location: location);

                  bool result = await controller1.createPost(post);

                  if (result == true) {
                    userController.sendNotifications();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                    ref.refresh(getAllPostsProvider);
                  } else {
                    print('error occured');
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF31473A),
              ),
              child: Text(
                'Post',
                style: TextStyle(
                  fontFamily: 'Poppins-Light',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Color(0XFFEDF4F2),
                ),
              ),
            ),
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
