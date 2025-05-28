import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/user_provider.dart';

class UsernameHistoryScreen extends StatelessWidget {
  const UsernameHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lịch sử username',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2C2C2C),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2C2C2C),
              Color(0xFF121212),
            ],
          ),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: userProvider.getUsernameHistory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final history = snapshot.data ?? [];

            if (history.isEmpty) {
              return const Center(
                  child: Text('Không có lịch sử',
                      style: TextStyle(fontSize: 18, color: Colors.white)));
            }

            return ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                final timestamp = item['timestamp'] as Timestamp?;
                final formattedTime = timestamp != null
                    ? DateFormat('dd/MM/yyyy HH:mm:ss')
                        .format(timestamp.toDate())
                    : 'Không rõ thời gian';

                return ListTile(
                  leading: const Icon(
                    Icons.history,
                    color: Colors.white,
                  ),
                  title: Text(
                    '${item['old_username']} - ${item['new_username']}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    formattedTime,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
