import 'package:flutter/material.dart';
import 'account.dart';
import '../main_app.dart';
import '../child_management/manage_child_page.dart';

class LoginPage extends StatefulWidget {
  final Account account;
  LoginPage({required this.account});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  String _error = '';
  bool _obscurePassword = true;

  final Color _green = const Color.fromARGB(255, 0, 93, 28);

  @override
  Widget build(BuildContext context) {
    return Theme(
      // removes defalt purple system theme (cursor + selection + focus glow)
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
          title: const Text('Login'),
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

                        // App icon
                        Icon(Icons.lock, size: 64, color: _green),

                        const SizedBox(height: 16),

                        // Title
                        Text(
                          'Login to Your Account',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: _green,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Name field
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

                        // Password field
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          cursorColor: _green,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),

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

                        const SizedBox(height: 24),

                        // Login button
                        ElevatedButton.icon(
                          onPressed: () {
                            if (_nameController.text == widget.account.name &&
                                widget.account.verifyPassword(_passwordController.text)) {
                              widget.account.logIn();

                              if (widget.account.currentChild.isEmpty) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (_) => ManageChildPage(
                                      account: widget.account,
                                      isRequired: true,
                                    ),
                                  ),
                                  (route) => false,
                                );
                              } else {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (_) => const MainApp(),
                                  ),
                                  (route) => false,
                                );
                              }
                            } else {
                              setState(() {
                                _error = 'Incorrect name or password!';
                              });
                            }
                          },
                          icon: const Icon(Icons.login),
                          label: const Text('Login'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Error text
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