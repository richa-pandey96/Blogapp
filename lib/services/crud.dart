import 'package:cloud_firestore/cloud_firestore.dart';

class CrudMethods {
  // Method to add data to Firestore
  Future<void> addData(Map<String, dynamic> blogData) async {
    try {
      await FirebaseFirestore.instance.collection("blogs").add(blogData);
    } catch (e) {
      print(e); // Ideally, use proper error handling
    }
  }

  // Method to retrieve data from Firestore
  Future<Stream<QuerySnapshot<Object?>>> getData() async {
    try {
      return FirebaseFirestore.instance.collection("blogs").snapshots();
    } catch (e) {
      print(e); // Ideally, use proper error handling
      throw e; // Re-throw the error after logging/handling
    }
  }
}