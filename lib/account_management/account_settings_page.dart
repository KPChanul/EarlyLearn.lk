import 'package:flutter/material.dart';
import 'account.dart';

class AccountSettingsPage extends StatefulWidget {
  final Account account;
  const AccountSettingsPage({super.key, required this.account});

  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  String _error = '';

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.account.name;
    _emailController.text = widget.account.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account Settings'), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.settings,
                      size: 64,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Update Your Account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 24),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _newPasswordController,
                      decoration: InputDecoration(
                        labelText: 'New Password (leave empty to keep current)',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm New Password',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _currentPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Current Password',
                        prefixIcon: Icon(Icons.security),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 16),
                    if (_error.isNotEmpty)
                      Text(
                        _error,
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _saveChanges,
                      icon: Icon(Icons.save),
                      label: Text('Save Changes'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveChanges() {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;
    String currentPassword = _currentPasswordController.text;

    if (!widget.account.verifyPassword(currentPassword)) {
      setState(() {
        _error = 'Incorrect current password!';
      });
      return;
    }

    if (name.isEmpty || email.isEmpty) {
      setState(() {
        _error = 'Name and email cannot be empty.';
      });
      return;
    }

    if (newPassword.isNotEmpty) {
      if (newPassword != confirmPassword) {
        setState(() {
          _error = 'New passwords do not match.';
        });
        return;
      }
      widget.account.setPassword(newPassword);
    }

    widget.account.setName(name);
    widget.account.setEmail(email);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Account updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }
}
