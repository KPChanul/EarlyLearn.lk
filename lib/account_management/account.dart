import 'package:hive_flutter/hive_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

part 'account.g.dart';

@HiveType(typeId: 1)
class Account extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String email;

  @HiveField(2)
  String passwordHash;

  @HiveField(3)
  int loggedIn;

  @HiveField(4)
  String currentChild;

  Account({
    required this.name,
    required this.email,
    required String password,
    this.loggedIn = 0,
    this.currentChild = '',
  }) : passwordHash = sha256.convert(utf8.encode(password)).toString();

  // ---------------------------
  // Getters
  // ---------------------------
  String getName() => name;
  String getEmail() => email;
  String getCurrentChild() => currentChild;
  int getLoggedIn() => loggedIn;

  bool verifyPassword(String password) {
    String hashed = sha256.convert(utf8.encode(password)).toString();
    return hashed == passwordHash;
  }

  // ---------------------------
  // Setters
  // ---------------------------
  void setName(String newName) {
    name = newName;
    save();
  }

  void setEmail(String newEmail) {
    email = newEmail;
    save();
  }

  void setPassword(String newPassword) {
    passwordHash = sha256.convert(utf8.encode(newPassword)).toString();
    save();
  }

  void logIn() {
    loggedIn = 1;
    save();
  }

  void logOut() {
    loggedIn = 0;
    save();
  }

  void setCurrentChild(String childName) {
    currentChild = childName;
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