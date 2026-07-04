import 'package:flutter/material.dart';
import 'account.dart';
import '../child_management/manage_child_page.dart';

class CreateAccountPage extends StatefulWidget {
  final Account? account;

  const CreateAccountPage({super.key, this.account});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _error = '';

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  final Color _green = const Color.fromARGB(255, 0, 93, 28);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      suffixIcon: suffixIcon,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: _green,
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: _green,
          selectionColor: _green.withOpacity(0.25),
          selectionHandleColor: _green,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Account'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 36, 118, 0),
          foregroundColor: Colors.white,
        ),
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
                        Icon(
                          Icons.person_add,
                          size: 64,
                          color: _green,
                        ),

                        const SizedBox(height: 16),

                        Text(
                          'Create Your Account',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: _green,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Parent Name
                        TextField(
                          controller: _nameController,
                          cursorColor: _green,
                          decoration: _inputDecoration(
                            label: 'Parent Name',
                            icon: Icons.person,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Email
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: _green,
                          decoration: _inputDecoration(
                            label: 'Email',
                            icon: Icons.email,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Password
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          cursorColor: _green,
                          decoration: _inputDecoration(
                            label: 'Password',
                            icon: Icons.lock,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: _green,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Confirm Password
                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirm,
                          cursorColor: _green,
                          decoration: _inputDecoration(
                            label: 'Confirm Password',
                            icon: Icons.lock_outline,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirm
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: _green,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirm = !_obscureConfirm;
                                });
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Create Account Button
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          onPressed: () async {
                            String name = _nameController.text.trim();
                            String email = _emailController.text.trim();
                            String password = _passwordController.text;
                            String confirm =
                                _confirmPasswordController.text;

                            if (name.isEmpty ||
                                email.isEmpty ||
                                password.isEmpty) {
                              setState(() {
                                _error = 'Please fill all fields.';
                              });
                              return;
                            }

                            if (password != confirm) {
                              setState(() {
                                _error = 'Passwords do not match.';
                              });
                              return;
                            }

                            setState(() {
                              _error = '';
                            });

                            final newAccount =
                                await Account.createAccount(
                              name: name,
                              email: email,
                              password: password,
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ManageChildPage(
                                  account: newAccount,
                                  isRequired: true,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.person_add),
                          label: const Text('Create Account'),
                        ),

                        const SizedBox(height: 16),

                        if (_error.isNotEmpty)
                          Text(
                            _error,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 244, 86, 54),
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
      ),
    );
  }
}