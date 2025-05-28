import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _username = '';
  String get username => _username;

  final _uid = FirebaseAuth.instance.currentUser?.uid;

  UserProvider() {
    if (_uid != null) {
      _loadUsername();
    }
  }

  Future<void> _loadUsername() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    _username = doc.data()?['username'] ?? 'Chưa có tên';
    notifyListeners();
  }

  Future<void> updateUsername(String newUsername) async {
    final oldUsername = _username; // Lưu tên cũ trước khi update
    _username = newUsername;
    notifyListeners();

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

    // Cập nhật tên mới
    await userRef.update({'username': newUsername});

    // Lưu lịch sử thay đổi với trường timestamp (để query được)
    await userRef.collection('username_history').add({
      'old_username': oldUsername,
      'new_username': newUsername,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

// Lấy lịch sử username sorted theo thời gian giảm dần
  Future<List<Map<String, dynamic>>> getUsernameHistory() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('username_history')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'old_username': data['old_username'] ?? '',
        'new_username': data['new_username'] ?? '',
        'timestamp': data['timestamp'] as Timestamp?,
      };
    }).toList();
  }
}
