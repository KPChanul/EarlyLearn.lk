import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'account_management/account.dart';
import 'account_management/login_page.dart';
import 'account_management/create_account_page.dart';
import 'account_management/home_page.dart';
import 'child_management/manage_child_page.dart';
import 'child_management/child.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters - MUST be before opening boxes
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(ChildAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(AccountAdapter());
  }

  // Open Hive boxes
  await Hive.openBox<Account>('accounts');
  await Hive.openBox<Child>('children');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EarlyLearn.lk',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: _buildHome(),
    );
  }

  Widget _buildHome() {
    try {
      final accountBox = Hive.box<Account>('accounts');
      final account = accountBox.isNotEmpty ? accountBox.values.first : null;

      // No account - show create account page
      if (account == null) {
        return CreateAccountPage(account: account);
      }

      // Account not logged in - show login page
      if (account.getLoggedIn() == 0) {
        return LoginPage(account: account);
      }

      // Account logged in but no current child - show manage child page
      if (account.getCurrentChild().isEmpty) {
        return ManageChildPage(
          account: account,
          isRequired: true,
        );
      }

      // Account logged in and has current child - show home page
      return HomePage(account: account);
    } catch (e) {
      return Scaffold(
        body: Center(
          child: Text('Error initializing app: $e'),
        ),
      );
    }
  }
}