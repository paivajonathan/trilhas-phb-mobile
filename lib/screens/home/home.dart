import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('trilhas').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(height: 150, child: Center(child: CircularProgressIndicator()));
              }
      
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('Sem dados'));
              }
      
              return Container(
                height: 150,
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    var data = doc.data() as Map<String, dynamic>;
                
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: 150,
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          children: [
                            Image.network("https://floridatrail.org/wp-content/uploads/2021/05/Thru-hike.jpg", fit: BoxFit.cover,)
                          ],
                        )
                      ),
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
