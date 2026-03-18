import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../account_management/account.dart';
import '../account_management/home_page.dart';
import '../child_management/child.dart';
import '../widgets/child_avatar.dart';

class ManageChildPage extends StatefulWidget {
  final Account account;
  final bool isRequired;

  ManageChildPage({
    required this.account,
    this.isRequired = false,
  });

  @override
  _ManageChildPageState createState() => _ManageChildPageState();
}

class _ManageChildPageState extends State<ManageChildPage> {
  late Box<Child> childBox;

  @override
  void initState() {
    super.initState();
    childBox = Hive.box<Child>('children');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !widget.isRequired,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Manage Children'),
          centerTitle: true,
          automaticallyImplyLeading: !widget.isRequired,
        ),
        body: Container(
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
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Add Child Button
                Container(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddChildDialog(),
                    icon: Icon(Icons.add_circle),
                    label: Text(
                      'Add New Child',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                // Children List
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: childBox.listenable(),
                    builder: (context, Box<Child> childBoxValue, _) {
                      if (childBoxValue.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              
                              SizedBox(height: 16),
                              Text(
                                'No children added yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: childBoxValue.length,
                        itemBuilder: (context, index) {
                          final child = childBoxValue.getAt(index);
                          final childName = child?.name ?? 'Unknown';
                          final isSelected =
                              widget.account.getCurrentChild() == childName;

                          return Card(
                            elevation: 4,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: isSelected
                                    ? Theme.of(context).primaryColor
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () => _selectChildWithPassword(childName),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: isSelected
                                        ? [
                                            Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.2),
                                            Colors.blue[100] ?? Colors.blue,
                                          ]
                                        : [
                                            Colors.white,
                                            Colors.grey[50] ?? Colors.grey,
                                          ],
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      ChildAvatar(childName, size: 70),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              childName,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'Age: ${child?.getAge()} years',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                            if (isSelected)
                                              Padding(
                                                padding: EdgeInsets.only(top: 4),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                  child: Text(
                                                    'Current Child',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () =>
                                            _deleteChildWithPassword(index, childName),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectChild(String childName) {
    widget.account.setCurrentChild(childName);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$childName is now the current child'),
        duration: Duration(seconds: 1),
      ),
    );

    // Always navigate to home page regardless of required mode
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomePage(account: widget.account),
          ),
        );
      }
    });
  }

  void _selectChildWithPassword(String childName) {
    _showPasswordDialog(
      title: 'Change Child',
      onConfirm: () {
        _selectChild(childName);
      },
    );
  }

  void _deleteChildWithPassword(int index, String childName) {
    _showPasswordDialog(
      title: 'Delete Child',
      onConfirm: () {
        _deleteChild(index, childName);
      },
    );
  }

  void _showPasswordDialog({
    required String title,
    required VoidCallback onConfirm,
  }) {
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.lock, color: Colors.orange),
            SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Enter your account password to proceed'),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (widget.account.verifyPassword(passwordController.text)) {
                Navigator.pop(context); // Close password dialog
                onConfirm();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Incorrect password!'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteChild(int index, String childName) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.orange),
            SizedBox(width: 8),
            Text('Delete Child'),
          ],
        ),
        content: Text('Are you sure you want to delete $childName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              childBox.deleteAt(index);

              // If deleted child was current, set current to null
              if (widget.account.getCurrentChild() == childName) {
                widget.account.setCurrentChild('');
              }

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$childName deleted'),
                  duration: Duration(seconds: 1),
                ),
              );
              setState(() {});
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddChildDialog() {
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.lock, color: Colors.orange),
            SizedBox(width: 8),
            Text('Verify Password'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Enter your account password to add a new child'),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (widget.account.verifyPassword(passwordController.text)) {
                Navigator.pop(context); // Close password dialog
                _showChildFormDialog(); // Show form to enter child details
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Incorrect password!'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: Text('Verify', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showChildFormDialog() {
    final nameController = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.person_add, color: Colors.blue),
              SizedBox(width: 8),
              Text('Child Details'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Child Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now()
                        .subtract(Duration(days: 365 * 3)), // Default 3 years old
                    firstDate: DateTime(2015),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() => selectedDate = picked);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          selectedDate == null
                              ? 'Select Date of Birth'
                              : 'DOB: ${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 14,
                            color: selectedDate == null
                                ? Colors.grey[600]
                                : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter child name')),
                  );
                  return;
                }
                if (selectedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select date of birth')),
                  );
                  return;
                }

                // Create the child
                final newChild = Child.create(
                  name: nameController.text.trim(),
                  dob: selectedDate!,
                );
                childBox.add(newChild);

                // Set as current child
                widget.account.setCurrentChild(newChild.name);

                Navigator.pop(context); // Close form dialog

                // Use mounted check and widget context to ensure navigation works
                if (!mounted) return;

                ScaffoldMessenger.of(this.context).showSnackBar(
                  SnackBar(
                    content: Text('${newChild.name} added successfully'),
                    duration: Duration(seconds: 1),
                  ),
                );

                // Navigate to home page using the page's own context
                Future.delayed(Duration(milliseconds: 300), () {
                  if (mounted) {
                    Navigator.pushReplacement(
                      this.context,
                      MaterialPageRoute(
                        builder: (_) => HomePage(account: widget.account),
                      ),
                    );
                  }
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
