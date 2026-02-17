// lib/features/home/presentation/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../auth/auth_controller.dart';
import '../profile/profile_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileControllerProvider);
    final user = profileState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Realtime Chat - Home'),
        actions: [
          IconButton(
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).signOut();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('สวัสดี, ${user?.screenName ?? user?.email ?? 'ผู้ใช้ใหม่'}'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.push('/profile'),
              child: const Text('ไปหน้าโปรไฟล์ของฉัน'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => context.push('/users/search'),
              child: const Text('ค้นหาผู้ใช้เพื่อแชท'),
            ),
          ],
        ),
      ),
    );
  }
}