import 'dart:io';

import 'package:blog_app/services/crud.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class CreateBlog extends StatefulWidget {
  const CreateBlog({super.key});

  @override
  State<CreateBlog> createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  String authorName = '';
  String title = '';
  String desc = '';

  File? pickedImage;
  bool _isLoading = false;

  final CrudMethods crudMethods = CrudMethods();
  XFile? image;
  bool isPicked = false;

  Future<void> getImage() async {
    final ImagePicker _picker = ImagePicker();
    image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (image != null) {
      setState(() {
        pickedImage = File(image!.path);
        isPicked = true;
      });
    }
  }

  Future<void> uploadBlog() async {
    if (pickedImage != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        FirebaseStorage storage = FirebaseStorage.instance;
        String filePath = "blogImages/${randomAlphaNumeric(9)}.jpg";
        Reference ref = storage.ref().child(filePath);

        UploadTask uploadTask = ref.putFile(pickedImage!);
        await uploadTask.whenComplete(() async {
          String downloadUrl = await ref.getDownloadURL();
          print("Uploaded Image URL: $downloadUrl");

          // Call your CRUD method to store the blog data with the image URL
          await crudMethods.addData({
            'imgUrl': downloadUrl,
            'authorName': authorName,
            'title': title,
            'desc': desc,
          });

          Navigator.pop(context);
        });
      } catch (error) {
        print("Error uploading image: $error");
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error uploading image: $error")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No image selected")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "My",
              style: TextStyle(fontSize: 22),
            ),
            Text(
              "Blog",
              style: TextStyle(fontSize: 22, color: Colors.blue),
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          GestureDetector(
            onTap: uploadBlog,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.file_upload),
            ),
          )
        ],
      ),
      body: _isLoading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: getImage,
                    child: pickedImage != null
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            height: 170,
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.file(
                                pickedImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            height: 170,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6)),
                            width: MediaQuery.of(context).size.width,
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.black45,
                            ),
                          ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(hintText: "Author Name"),
                          onChanged: (val) {
                            setState(() {
                              authorName = val;
                            });
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(hintText: "Title"),
                          onChanged: (val) {
                            setState(() {
                              title = val;
                            });
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(hintText: "Description"),
                          onChanged: (val) {
                            setState(() {
                              desc = val;
                            });
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}