import 'package:early_learn/account_management/account.dart';
import 'package:early_learn/account_management/account_settings_page.dart';
import 'package:early_learn/account_management/home_page.dart';
import 'package:early_learn/account_management/login_page.dart';
import 'package:early_learn/child_management/manage_child_page.dart';
import 'package:early_learn/widgets/child_avatar.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Account? _account;

  @override
  void initState() {
    super.initState();
    _loadAccount();
  }

  void _loadAccount() {
    try {
      final accountBox = Hive.box<Account>('accounts');
      setState(() {
        _account = accountBox.isNotEmpty ? accountBox.values.first : null;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color.fromARGB(255, 193, 233, 108),const Color.fromARGB(255, 184, 235, 102), const Color.fromARGB(255, 62, 178, 83)],
          ),
        ),
        child: SafeArea(
          child: _account == null
              ? const Center(child: Text('No account'))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(24),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [ const Color.fromARGB(130, 215, 255, 156),const Color.fromARGB(130, 236, 255, 149),const Color.fromARGB(130, 253, 255, 146)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (_account != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ManageChildPage(
                                  account: _account!,
                                ),
                              ),
                            ).then((_) => _loadAccount());
                          }
                        },
                        child: Column(
                          children: [
                            ChildAvatar(
                              _account!.currentChild.isNotEmpty
                                  ? _account!.currentChild
                                  : 'No Child',
                              size: 100,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _account!.currentChild.isNotEmpty
                                  ? _account!.currentChild
                                  : 'No child selected',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 11, 132, 0),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Tap to manage child account',
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 122, 45),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: GestureDetector(
                        onTap: () {
                          if (_account != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AccountSettingsPage(
                                  account: _account!,
                                ),
                              ),
                            ).then((_) => _loadAccount());
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 0, 153, 61),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.settings, color: Colors.white, size: 24),
                              SizedBox(width: 12),
                              Text(
                                'Settings',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: GestureDetector(
                        onTap: () {
                          if (_account != null) {
                            _account!.logOut();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => LoginPage(account: _account!),
                              ),
                              (route) => false,
                            );
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 0, 96, 31),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout, color: Colors.white, size: 24),
                              SizedBox(width: 12),
                              Text(
                                'Logout',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
