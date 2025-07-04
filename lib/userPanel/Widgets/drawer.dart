import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptop_harbor/controller/getUserData.dart';
import 'package:laptop_harbor/userPanel/Profile.dart';
import 'package:laptop_harbor/userPanel/contact_feedback.dart';
import 'package:laptop_harbor/userPanel/login.dart';
import 'package:laptop_harbor/userPanel/rate_us.dart';
import 'package:laptop_harbor/userPanel/terms_and_conditions.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({super.key});
  final Getuserdatacontroller getuserdatacontroller = Get.put(Getuserdatacontroller());
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // If user is not logged in
    if (user == null) {
      return Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset('assets/images/logo2.png', height: 40),
              ),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.login),
                title: Text('Login'),
                onTap: () => Get.to(Login()),
              ),
              ListTile(
                leading: Icon(Icons.article_outlined),
                title: Text('Terms & Conditions'),
                onTap: () => Get.to(TermsAndConditions()),
              ),
            ],
          ),
        ),
      );
    }

    // If user is logged in
    final uid = user.uid;

    return Drawer(
      child: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: getuserdatacontroller.getuserdata(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Icon(Icons.error));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Data Not Found!'));
          }

          final doc = snapshot.data!.first;
          final data = doc.data() as Map<String, dynamic>;
          final isAdmin = data['isAdmin'] == true;

          return Drawer(
            backgroundColor: Colors.white,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset('assets/images/logo2.png', height: 40),
                  ),
                  SizedBox(height: 10),
                  if (isAdmin) ...[
                    ListTile(
                      leading: Icon(Icons.dashboard),
                      title: Text('Profile'),
                      onTap: () => Get.to(Profile()),
                    ),
                    ListTile(
                      leading: Icon(Icons.people_outline_outlined),
                      title: Text('Manage Users'),
                    ),
                    ListTile(
                      leading: Icon(Icons.category_outlined),
                      title: Text('Categories'),
                    ),
                    ListTile(
                      leading: Icon(Icons.shopping_bag),
                      title: Text('Manage Products'),
                    ),
                  ] else ...[
                     ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Profile'),
                      onTap: () => Get.to(Profile()),
                    ),
                    ListTile(
                      leading: Icon(Icons.list),
                      title: Text('Orders'),
                    ),
                    ListTile(
                      leading: Icon(Icons.location_on_outlined),
                      title: Text('Address'),
                    ),
                    ListTile(
                      leading: Icon(Icons.star),
                      title: Text('Rate Us'),
                      onTap: () => Get.to(RateUsPage()),
                    ),
                     ListTile(
                      leading: Icon(Icons.contact_support_outlined),
                      title: Text('Contact & Feedback'),
                      onTap: () => Get.to(ContactFeedbackPage()),
                    ),
                    ListTile(
                      leading: Icon(Icons.article_outlined),
                      title: Text('Terms & Conditions'),
                      onTap: () => Get.to(TermsAndConditions()),
                    ),
                  ],
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.logout_outlined, color: Colors.red),
                    title: Text('Logout', style: TextStyle(color: Colors.red)),
                    onTap: () {
                      _auth.signOut();
                      Get.off(Login());
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
