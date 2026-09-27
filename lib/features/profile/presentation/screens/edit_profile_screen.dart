import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/profile_data.dart';
import '../widgets/avatar_with_level_badge.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late int _avatarIndex;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final profile = ProfileData.instance.profile;
    _nameController = TextEditingController(text: profile.displayName);
    _avatarIndex = profile.avatarIndex;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a display name.')),
      );
      return;
    }
    setState(() => _saving = true);
    await ProfileData.instance.updateProfile(
      displayName: name,
      avatarIndex: _avatarIndex,
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: ProfileAvatarWithLevelBadge(
              level: 'Edit',
              avatarIndex: _avatarIndex,
              radius: 50,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _nameController,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Display name',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Choose an avatar',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(5, (index) {
              return ChoiceChip(
                label: Icon(
                  [
                    Icons.person,
                    Icons.face,
                    Icons.emoji_people,
                    Icons.school,
                    Icons.auto_awesome,
                  ][index],
                  color: AppColors.primary,
                ),
                selected: _avatarIndex == index,
                onSelected: (_) => setState(() => _avatarIndex = index),
              );
            }),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _saving ? null : _save,
            child: Text(_saving ? 'Saving...' : 'Save Changes'),
          ),
        ],
      ),
    );
  }
}
