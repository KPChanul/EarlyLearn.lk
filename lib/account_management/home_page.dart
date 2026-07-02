import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../account_management/account.dart';
import '../account_management/account_settings_page.dart';
import '../account_management/login_page.dart';
import '../child_management/manage_child_page.dart';
import '../child_management/child.dart';
import '../widgets/child_avatar.dart';

class HomePage extends StatefulWidget {
  final Account account;
  const HomePage({super.key, required this.account});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box<Child> childBox;

  @override
  void initState() {
    super.initState();
    childBox = Hive.box<Child>('children');
  }

  Child? _getCurrentChild() {
    final childName = widget.account.currentChild;
    if (childName.isEmpty) return null;

    for (int i = 0; i < childBox.length; i++) {
      final child = childBox.getAt(i);
      if (child?.name == childName) {
        return child;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final currentChild = _getCurrentChild();

    // If no current child, redirect to manage child page
    if (currentChild == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ManageChildPage(account: widget.account, isRequired: true),
          ),
        );
      });
    }

    return PopScope(
      canPop: false, // Prevent back button
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          centerTitle: true,
          elevation: 4,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: Center(
                child: Text(
                  widget.account.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.1),
                  Colors.blue[50] ?? Colors.blue,
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  // Child Profile Card
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).primaryColor,
                            Colors.blue[700] ?? Colors.blue,
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Column(
                          children: [
                            if (currentChild != null)
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ManageChildPage(
                                        account: widget.account,
                                      ),
                                    ),
                                  ).then((_) => setState(() {}));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: EdgeInsets.all(4),
                                  child: Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      ChildAvatar(currentChild.name, size: 120),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                        ),
                                        padding: EdgeInsets.all(6),
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            SizedBox(height: 20),
                            Text(
                              currentChild?.name ?? 'No Child Selected',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.cake, color: Colors.white, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  currentChild != null
                                      ? 'Age: ${currentChild.getAge()} years'
                                      : '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  // Action Buttons
                  SizedBox(
                    width: 140,
                    child: _buildActionButton(
                      context,
                      icon: Icons.settings,
                      label: 'Settings',
                      color: Colors.orange,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AccountSettingsPage(account: widget.account),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 40),
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showLogoutConfirmation();
                      },
                      icon: Icon(Icons.logout, size: 24),
                      label: Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 120,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.8), color],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 8),
            Text('Logout'),
          ],
        ),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              // Logout
              widget.account.logOut();
              Navigator.pop(context); // Close dialog

              // Navigate back to login
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => LoginPage(account: widget.account),
                ),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
