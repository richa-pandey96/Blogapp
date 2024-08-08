import 'dart:async';

import 'package:blog_app/services/crud.dart';
import 'package:blog_app/views/create_blog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  CrudMethods crudMethods=new CrudMethods();

  Stream<QuerySnapshot>?blogsStream;

  Widget BlogsList(){
    return  blogsStream!=null
      ?StreamBuilder<QuerySnapshot>(
            stream: blogsStream, builder: (context,snapshot){
              if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());

    } if (snapshot.hasError) {
      return Center(child: Text("Error: ${snapshot.error}"));

    }  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return Center(child: Text("No blogs available"));

    }
             return ListView.builder(
  padding: EdgeInsets.symmetric(horizontal: 16),          
  itemCount: snapshot.data!.docs.length,
  shrinkWrap: true,
  itemBuilder: (context, index) {
    // Retrieve the data map from the document
    var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;

    // Safely access the fields, providing default values if they are null
    String imgUrl = data['imgUrl'] ?? ''; // Default to empty string if null
    String title = data['title'] ?? 'No Title'; // Default to 'No Title' if null
    String description = data['desc'] ?? 'No Description'; // Default to 'No Description' if null
    String authorName = data['authorName'] ?? 'Unknown Author'; // Default to 'Unknown Author' if null

    // Create and return the BlogsTile widget with the retrieved data
    return BlogsTile(
      imgUrl: imgUrl,
      title: title,
      description: description,
      authorName: authorName,
    );
  },
);
},

)
:Center(child: CircularProgressIndicator()
            );
      
    
  }





  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // crudMethods.getData().then((result){
    //   blogsSnapshot=result;

    // });
    crudMethods.getData().then((result) {
  
  setState(() {
    blogsStream = result;
  });
}).catchError((error) {
  print("Error fetching data: $error");
});
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
              style: TextStyle(fontSize: 22,color: Colors.blue),
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: BlogsList(),
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment:MainAxisAlignment.center,
          children: [
            FloatingActionButton(onPressed: () {
              Navigator.push(context, 
              MaterialPageRoute(builder: (context)=>CreateBlog()));
            },
            child: Icon(Icons.add),
            )
          ],

        ),
      ),
    );
  }
} 

class BlogsTile extends StatelessWidget {
  //const BlogsTile({super.key});
  String imgUrl,title,description,authorName;
  BlogsTile(
    {required this.imgUrl,
    required this.title,
    required this.description,
    required this.authorName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      height: 150,
      child: Stack(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: CachedNetworkImage(imageUrl: imgUrl,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
          ),
          ),
        Container(
          height: 170,
          decoration: BoxDecoration(
            color: Colors.black45.withOpacity(0.3),
            borderRadius: BorderRadius.circular(6)
            ),

        ),
        Container(
          
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          Text(title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25,fontWeight:FontWeight.w500 ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(description,
          style: TextStyle(fontSize: 22,fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 4,
          ),
          Text(authorName)
        ],),)
      ],),
    );
  }
} 