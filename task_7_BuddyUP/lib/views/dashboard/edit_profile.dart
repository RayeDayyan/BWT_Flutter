import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_7_buddyup/controllers/providers/user_provider.dart';
import 'package:task_7_buddyup/controllers/services/user_controller.dart';
import 'package:task_7_buddyup/views/widgets/custom_app_bar.dart';

class EditProfile extends ConsumerStatefulWidget {
  @override
  ConsumerState<EditProfile> createState() => EditProfileState();
}

class EditProfileState extends ConsumerState<EditProfile> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emergencyController = TextEditingController();
  TextEditingController passController = TextEditingController();

  bool check2 = false;

  XFile? image;
  final imagePicker = ImagePicker();

  Future<void> selectImage() async {
    final selectedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        image = selectedImage;
        check2 = true;
      });
    }
  }

  bool check = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: ref.watch(userProvider).when(data: (userModel) {
        return ListView(padding: EdgeInsets.all(30), children: [
          GestureDetector(
            onTap: selectImage,
            child: CircleAvatar(
              radius: 15.w,
              backgroundImage: check2
                  ? image != null
                      ? FileImage(File(image!.path))
                      : null
                  : NetworkImage(userModel.Profile!),
            ),
          ),
          Text(
            'Email',
            style: TextStyle(
              fontFamily: 'Poppins-Light',
              fontSize: 18.sp,
            ),
          ),
          TextField(
            controller: emailController,
            style: const TextStyle(
              fontFamily: 'Poppins-Light',
            ),
            decoration: InputDecoration(
              hintText: userModel.Email ?? 'Email',
              hintStyle: TextStyle(
                fontFamily: 'Poppins-Light',
                fontSize: 14.sp,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          Text(
            'Full Name',
            style: TextStyle(
              fontFamily: 'Poppins-Light',
              fontSize: 18.sp,
            ),
          ),
          TextField(
            controller: nameController,
            style: const TextStyle(
              fontFamily: 'Poppins-Light',
            ),
            decoration: InputDecoration(
              hintText: userModel.Name ?? 'Name',
              hintStyle: TextStyle(
                fontFamily: 'Poppins-Light',
                fontSize: 14.sp,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          Text(
            'Age',
            style: TextStyle(
              fontFamily: 'Poppins-Light',
              fontSize: 18.sp,
            ),
          ),
          TextField(
            controller: ageController,
            style: const TextStyle(
              fontFamily: 'Poppins-Light',
            ),
            decoration: InputDecoration(
              hintText: userModel.Age.toString() ?? 'Age',
              hintStyle: TextStyle(
                fontFamily: 'Poppins-Light',
                fontSize: 14.sp,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          Text(
            'Bio',
            style: TextStyle(
              fontFamily: 'Poppins-Light',
              fontSize: 18.sp,
            ),
          ),
          TextField(
            controller: bioController,
            style: const TextStyle(
              fontFamily: 'Poppins-Light',
            ),
            decoration: InputDecoration(
              hintText: userModel.Bio ?? 'Bio',
              hintStyle: TextStyle(
                fontFamily: 'Poppins-Light',
                fontSize: 14.sp,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          Text(
            'Phone Number',
            style: TextStyle(
              fontFamily: 'Poppins-Light',
              fontSize: 18.sp,
            ),
          ),
          TextField(
            controller: phoneController,
            style: const TextStyle(
              fontFamily: 'Poppins-Light',
            ),
            decoration: InputDecoration(
              hintText: userModel.Contact ?? 'Contact',
              hintStyle: TextStyle(
                fontFamily: 'Poppins-Light',
                fontSize: 14.sp,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          Text(
            'Emergency Contact',
            style: TextStyle(
              fontFamily: 'Poppins-Light',
              fontSize: 18.sp,
            ),
          ),
          TextField(
            controller: emergencyController,
            style: const TextStyle(
              fontFamily: 'Poppins-Light',
            ),
            decoration: InputDecoration(
              hintText: userModel.Emergency ?? 'Emergency',
              hintStyle: TextStyle(
                fontFamily: 'Poppins-Light',
                fontSize: 14.sp,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          Text(
            'Password',
            style: TextStyle(
              fontFamily: 'Poppins-Light',
              fontSize: 18.sp,
            ),
          ),
          TextField(
            controller: passController,
            style: const TextStyle(
              fontFamily: 'Poppins-Light',
            ),
            decoration: InputDecoration(
              hintText: userModel.Password ?? 'Pass',
              hintStyle: TextStyle(
                fontFamily: 'Poppins-Light',
                fontSize: 14.sp,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Container(
              height: 6.5.h,
              child: ElevatedButton(
                  onPressed: updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color((0xFF31473A)),
                  ),
                  child: Text(
                    'Done',
                    style: TextStyle(
                      fontFamily: 'Ember Light',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Color(0XFFEDF4F2),
                    ),
                  ))),
          SizedBox(
            height: 2.h,
          )
        ]);
      }, error: (error, stackTree) {
        Text('error occured');
      }, loading: () {
        return Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }

  void updateProfile() async {
    Map<String, dynamic> updatedData = {};
    if (emailController.text.isNotEmpty) {
      check = true;
      updatedData['email'] = emailController.text.toString();
    }

    if (nameController.text.isNotEmpty) {
      check = true;
      updatedData['name'] = nameController.text.toString();
    }

    if (ageController.text.isNotEmpty) {
      check = true;
      updatedData['age'] = int.parse(ageController.text.toString());
    }

    if (bioController.text.isNotEmpty) {
      check = true;
      updatedData['bio'] = bioController.text.toString();
    }

    if (phoneController.text.isNotEmpty) {
      check = true;
      updatedData['contact'] = phoneController.text.toString();
    }

    if (emergencyController.text.isNotEmpty) {
      check = true;
      updatedData['emergency'] = emergencyController.text.toString();
    }

    if (passController.text.isNotEmpty) {
      check = true;
      updatedData['password'] = passController.text.toString();
    }

    bool result = true;

    final controller = UserController();

    if (check == true) {
      result = await controller.updateUser(updatedData);
      if (result == false) {
        print('unsuccessful');
      } else {
        ref.refresh(userProvider);
      }
      check = false;
    }

    bool result2 = true;
    if (check2 == true) {
      result2 = await controller.updatePicture(image!);

      if (result2 == true) {
        ref.refresh(userProvider);
      } else {
        print('unsuccessful');
      }
      check2 = false;
    }

    Navigator.pop(context);
  }
}
