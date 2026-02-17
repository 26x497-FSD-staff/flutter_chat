// lib/features/users/presentation/user_search_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_search_controller.dart';

class UserSearchScreen extends ConsumerStatefulWidget {
  const UserSearchScreen({super.key});

  @override
  ConsumerState<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends ConsumerState<UserSearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    ref.read(userSearchControllerProvider.notifier).search(value.trim());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userSearchControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ค้นหาผู้ใช้'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'ค้นหาด้วย screen name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          if (state.isLoading) const LinearProgressIndicator(),
          if (state.error != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                state.error!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: state.results.length,
              itemBuilder: (context, index) {
                final user = state.results[index];
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(user.screenName ?? user.email),
                  subtitle: user.hobbies.isNotEmpty
                      ? Text('Hobbies: ${user.hobbies.join(', ')}')
                      : null,
                  onTap: () {
                    // ในขั้นถัดไป: ไปหน้า chat กับ user รายนี้
                    // ตัวอย่าง: context.push('/chat/${user.id}');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('จะไปแชทกับ ${user.screenName ?? user.email}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}