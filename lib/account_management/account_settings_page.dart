import 'package:flutter/material.dart';
import 'account.dart';

class AccountSettingsPage extends StatefulWidget {
  final Account account;
  AccountSettingsPage({required this.account});

  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}
//controllers
class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  String _error = '';

  final Color _green = const Color.fromARGB(255, 0, 93, 28);

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.account.name;
    _emailController.text = widget.account.email;
  }

  @override
Widget build(BuildContext context) {
  return Theme(
    // removes defalt purple system theme (cursor + selection + focus glow)
    data: Theme.of(context).copyWith(
      colorScheme: Theme.of(context).colorScheme.copyWith(
        primary: _green,
        secondary: _green,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: _green,
        selectionColor: _green.withOpacity(0.25),
        selectionHandleColor: _green,
      ),
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelStyle: TextStyle(
          color: _green,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    child: Scaffold(
      //app bar
      appBar: AppBar(
        title: const Text('Account Settings'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 36, 118, 0),
        foregroundColor: Colors.white,
      ),

      //  background 
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _green.withOpacity(0.08),
              Colors.white,
            ],
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: SingleChildScrollView(
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      // Settings icon 
                      Icon(
                        Icons.settings,
                        size: 64,
                        color: _green,
                      ),

                      const SizedBox(height: 16),

                      // Title 
                      const Text(
                        'Update Your Account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // NAME FIELD
                      TextField(
                        controller: _nameController,
                        cursorColor: _green,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          prefixIcon: const Icon(Icons.person),
                          
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                              width: 1.2,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: _green,
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // EMAIL FIELD
                      TextField(
                        controller: _emailController,
                        cursorColor: _green,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email),

                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                              width: 1.2,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: _green,
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // NEW PASSWORD
                      TextField(
                        controller: _newPasswordController,
                        cursorColor: _green,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          prefixIcon: const Icon(Icons.lock),

                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                              width: 1.2,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: _green,
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // CONFIRM PASSWORD
                      TextField(
                        controller: _confirmPasswordController,
                        cursorColor: _green,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: const Icon(Icons.lock_outline),

                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                              width: 1.2,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: _green,
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // CURRENT PASSWORD
                      TextField(
                        controller: _currentPasswordController,
                        cursorColor: _green,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Current Password',
                          prefixIcon: const Icon(Icons.security),

                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                              width: 1.2,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: _green,
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ERROR TEXT
                      if (_error.isNotEmpty)
                        Text(
                          _error,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 255, 58, 58),
                            fontSize: 16,
                          ),
                        ),

                      const SizedBox(height: 24),

                      // SAVE BUTTON
                      ElevatedButton.icon(
                        onPressed: _saveChanges,
                        icon: const Icon(Icons.save),
                        label: const Text('Save Changes'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),);
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
      const SnackBar(
        content: Text('Account updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }
}