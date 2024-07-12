import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _currentPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;

  late User? _currentUser;
  late String _username = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    fetchUsername();
  }

  void fetchUsername() async {
    if (_currentUser != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(_currentUser!.uid)
                .get();
        setState(() {
          _username = snapshot.data()?['username'] ?? 'N/A';
        });
      } catch (e) {
        print('Error fetching username: $e');
        setState(() {
          _username = 'N/A';
        });
      }
    }
  }

  void _changePassword() async {
    setState(() {
      _currentPasswordError = null;
      _newPasswordError = null;
      _confirmPasswordError = null;
    });

    if (_formKey.currentState!.validate()) {
      try {
        if (_currentUser != null) {
          setState(() {
            _isLoading = true;
          });

          AuthCredential credential = EmailAuthProvider.credential(
            email: _currentUser!.email!,
            password: _passwordController.text,
          );

          await _currentUser!.reauthenticateWithCredential(credential);

          if (_newPasswordController.text != _confirmPasswordController.text) {
            setState(() {
              _confirmPasswordError = 'Passwords do not match';
              _isLoading = false;
            });
            return;
          }

          if (_newPasswordController.text.length < 8) {
            setState(() {
              _newPasswordError = 'Password must be at least 8 characters';
              _isLoading = false; 
            });
            return;
          }

          await _currentUser!.updatePassword(_newPasswordController.text);

          _passwordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();

          Get.snackbar('Success!', 'Password updated successfully');
          Navigator.pop(context);
        } else {
          Get.snackbar('Oops!', 'User not found');
        }
      } catch (e) {

        
        if (e is FirebaseAuthException) {
          if (e.code == 'wrong-password') {
            setState(() {
              _currentPasswordError = 'Incorrect current password';
              _isLoading = false; 
            });
          } else {
            setState(() {
              _newPasswordError = 'Error updating password';
              _isLoading = false; 
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_currentUser != null) ...[
                  const Text(
                    'Current User Details:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Email:', style: TextStyle(fontSize: 16)),
                          Text(
                            _currentUser!.email ?? 'N/A',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text('Username:',
                              style: TextStyle(fontSize: 16)),
                          Text(
                            _username,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Current Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your current password';
                    }
                    return null;
                  },
                  obscureText: true,
                  onChanged: (_) {
                    setState(() {
                      _currentPasswordError = null;
                    });
                  },
                ),
                if (_currentPasswordError != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      _currentPasswordError!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _newPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                  obscureText: true,
                  onChanged: (_) {
                    setState(() {
                      _newPasswordError = null;
                    });
                  },
                ),
                if (_newPasswordError != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      _newPasswordError!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm New Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  obscureText: true,
                  onChanged: (_) {
                    setState(() {
                      _confirmPasswordError = null;
                    });
                  },
                ),
                if (_confirmPasswordError != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      _confirmPasswordError!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _changePassword,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Change Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
