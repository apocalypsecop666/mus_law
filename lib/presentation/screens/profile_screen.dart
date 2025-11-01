import 'package:flutter/material.dart';
import 'package:mus_law/core/utils/validators.dart';
import 'package:mus_law/data/repositories/auth_repository.dart';
import 'package:mus_law/data/repositories/user_repository.dart';
import 'package:mus_law/domain/entities/user_entity.dart';
import 'package:mus_law/presentation/screens/login_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  bool _isLoading = false;
  UserEntity? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (!mounted) return;

    final authRepo = Provider.of<AuthRepository>(context, listen: false);
    final user = await authRepo.getCurrentUser();

    if (!mounted) return;

    setState(() {
      _currentUser = user;
      _nameController.text = user?.name ?? '';
      _emailController.text = user?.email ?? '';
    });
  }

  Future<void> _updateUser() async {
    if (_currentUser == null || !_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedUser = UserEntity(
        id: _currentUser!.id,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _currentUser!.password,
      );

      final userRepo = Provider.of<UserRepository>(context, listen: false);
      await userRepo.updateUser(updatedUser);

      if (!mounted) return;

      setState(() {
        _isEditing = false;
        _isLoading = false;
        _currentUser = updatedUser;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  Future<void> _deleteAccount() async {
    if (_currentUser == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      final userRepo = Provider.of<UserRepository>(context, listen: false);
      final authRepo = Provider.of<AuthRepository>(context, listen: false);

      await userRepo.deleteUser(_currentUser!.email);
      await authRepo.logout();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute<Map<dynamic, dynamic>>(
          builder: (_) => const LoginScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete account')),
      );
    }
  }

  Future<void> _logout() async {
    final authRepo = Provider.of<AuthRepository>(context, listen: false);
    await authRepo.logout();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute<Map<dynamic, dynamic>>(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _nameController.text = _currentUser?.name ?? '';
      _emailController.text = _currentUser?.email ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: _isLoading
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
        actions: _isEditing || _currentUser == null
            ? null
            : [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => setState(() => _isEditing = true),
                ),
              ],
      ),
      body: _currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.amber[100],
                          child: Text(
                            _currentUser!.name[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (_isEditing)
                          Column(
                            children: [
                              TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                  border: OutlineInputBorder(),
                                ),
                                validator: Validators.validateName,
                              ),
                              const SizedBox(height: 15),
                              TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(),
                                ),
                                validator: Validators.validateEmail,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: _cancelEdit,
                                      child: const Text('Cancel'),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _updateUser,
                                      child: const Text('Save'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        else
                          Column(
                            children: [
                              Text(
                                _currentUser!.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                _currentUser!.email,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        if (!_isEditing) ...[
                          ListTile(
                            leading: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            title: const Text('Favorite Songs'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.download,
                              color: Colors.blue,
                            ),
                            title: const Text('Downloads'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.settings,
                              color: Colors.grey,
                            ),
                            title: const Text('Settings'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {},
                          ),
                        ],
                        const Spacer(),
                        OutlinedButton(
                          onPressed: _deleteAccount,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                          child: const Text('Delete Account'),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _logout,
                            child: const Text('Logout'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
