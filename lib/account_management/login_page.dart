import 'package:flutter/material.dart';
import 'account.dart';
import '../main_app.dart';
import '../child_management/manage_child_page.dart';

class LoginPage extends StatefulWidget {
  final Account account;
  const LoginPage({super.key, required this.account});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _error = '';
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login'), centerTitle: true),
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
                    Text(
                      'Login to your account',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
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
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                      ),
                      obscureText: _obscurePassword,
                    ),

                    SizedBox(height: 24),

                    ElevatedButton.icon(
                      onPressed: () {
                        if (_nameController.text == widget.account.name &&
                            widget.account.verifyPassword(
                              _passwordController.text,
                            )) {
                          widget.account.logIn();

                          // Check if current child exists
                          if (widget.account.currentChild.isEmpty) {
                            // Navigate to manage child page
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
                            // Navigate to main app
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
                      icon: Icon(Icons.login),
                      label: Text('Login'),
                    ),

                    SizedBox(height: 16),

                    if (_error.isNotEmpty)
                      Text(
                        _error,
                        style: TextStyle(color: Colors.red, fontSize: 16),
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
}
