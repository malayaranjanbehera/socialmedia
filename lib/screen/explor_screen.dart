import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExplorScreen extends StatefulWidget {
  const ExplorScreen({super.key});

  @override
  State<ExplorScreen> createState() => _ExplorScreenState();
}

class _ExplorScreenState extends State<ExplorScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  Stream<QuerySnapshot<Map<String, dynamic>>> _getUsersStream() {
    if (_searchText.isEmpty) {
      return FirebaseFirestore.instance
          .collection('users')
          .orderBy('username')
          .limit(10)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: _searchText)
          .where('username', isLessThan: _searchText + 'z')
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search users...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              _searchText = value.trim();
            });
          },
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _getUsersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index].data();
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user['profileImage'] ?? ''),
                ),
                title: Text(user['username'] ?? 'Unknown'),
                subtitle: Text(user['email'] ?? ''),
                onTap: () {
                  // Optionally navigate to user profile
                },
              );
            },
          );
        },
      ),
    );
  }
}
