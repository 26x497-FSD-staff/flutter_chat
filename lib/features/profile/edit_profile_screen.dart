// lib/features/profile/presentation/edit_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'profile_controller.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _screenNameController;
  late TextEditingController _hobbiesController;
  String? _error;

  @override
  void initState() {
    super.initState();
    final user = ref.read(profileControllerProvider).user;
    _screenNameController = TextEditingController(text: user?.screenName ?? '');
    _hobbiesController = TextEditingController(
      text: user?.hobbies.join(', ') ?? '',
    );
  }

  @override
  void dispose() {
    _screenNameController.dispose();
    _hobbiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);
    final isLoading = profileState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  if (_error != null)
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  TextFormField(
                    controller: _screenNameController,
                    decoration: const InputDecoration(
                      labelText: 'Screen name',
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'กรุณาใส่ชื่อแสดง' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _hobbiesController,
                    decoration: const InputDecoration(
                      labelText: 'Hobbies (คั่นด้วย , เช่น ฟุตบอล,หนัง,เที่ยว)',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: isLoading ? null : _onSavePressed,
                    child: const Text('บันทึก'),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            const ColoredBox(
              color: Colors.black26,
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Future<void> _onSavePressed() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _error = null);

    final screenName = _screenNameController.text.trim();
    final hobbiesText = _hobbiesController.text.trim();
    final hobbies = hobbiesText.isEmpty
        ? <String>[]
        : hobbiesText.split(',').map((e) => e.trim()).toList();

    try {
      await ref
          .read(profileControllerProvider.notifier)
          .updateProfile(screenName: screenName, hobbies: hobbies);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }
}