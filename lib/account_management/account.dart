import 'package:hive_flutter/hive_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

part 'account.g.dart';

@HiveType(typeId: 1)
class Account extends HiveObject {
  @HiveField(0)
  String _name;

  @HiveField(1)
  String _email;

  @HiveField(2)
  String _passwordHash;

  @HiveField(3)
  int _loggedIn;

  @HiveField(4)
  String _currentChild;

  Account({
    String name = '',
    String email = '',
    String password = '',
    int loggedIn = 0,
    String currentChild = '',
  })  : _name = name,
        _email = email,
        _loggedIn = loggedIn,
        _currentChild = currentChild,
        _passwordHash = password.isEmpty 
            ? '' 
            : sha256.convert(utf8.encode(password)).toString();

  // ---------------------------
  // Getters
  // ---------------------------
  String get name => _name;
  String get email => _email;
  String get currentChild => _currentChild;
  bool get isLoggedIn => _loggedIn == 1;

  bool verifyPassword(String password) {
    String hashed = sha256.convert(utf8.encode(password)).toString();
    return hashed == _passwordHash;
  }

  // ---------------------------
  // Setters
  // ---------------------------
  void setName(String newName) {
    _name = newName;
    save();
  }

  void setEmail(String newEmail) {
    _email = newEmail;
    save();
  }

  void setPassword(String newPassword) {
    _passwordHash = sha256.convert(utf8.encode(newPassword)).toString();
    save();
  }

  void logIn() {
    _loggedIn = 1;
    save();
  }

  void logOut() {
    _loggedIn = 0;
    save();
  }

  void setCurrentChild(String childName) {
    _currentChild = childName;
    save();
  }

  // ---------------------------
  // Factory for creating account
  // ---------------------------
  static Future<Account> createAccount({
    required String name,
    required String email,
    required String password,
  }) async {
    final box = Hive.box<Account>('accounts');
    final account = Account(name: name, email: email, password: password, loggedIn: 1);
    await box.put(email, account);
    return account;
  }

  // ---------------------------
  // Load account by email
  // ---------------------------
  static Account? loadAccount(String email) {
    final box = Hive.box<Account>('accounts');
    return box.get(email);
  }
}