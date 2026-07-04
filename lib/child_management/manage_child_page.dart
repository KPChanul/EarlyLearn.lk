import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../account_management/account.dart';
import 'package:early_learn/main_app.dart';
import 'child.dart';
import '../widgets/child_avatar.dart';

class ManageChildPage extends StatefulWidget {
  final Account account;
  // Controls whether this page is required during account setup
  // true = user cannot leave until completed
  // false = normal page with back navigation
  final bool isRequired;

  const ManageChildPage({
    super.key,
    required this.account,
    this.isRequired = false,
  });

  @override
  State<ManageChildPage> createState() => _ManageChildPageState();
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
  final Color green = const Color.fromARGB(255, 0, 93, 28);

  return Theme(
    // removes default purple system theme (cursor + selection + focus glow)
    data: Theme.of(context).copyWith(
      colorScheme: Theme.of(context).colorScheme.copyWith(
        primary: green,
        secondary: green,
      ),

      textSelectionTheme: TextSelectionThemeData(
        cursorColor: green,
        selectionColor: green.withOpacity(0.25),
        selectionHandleColor: green,
      ),

      inputDecorationTheme: InputDecorationTheme(
        floatingLabelStyle: TextStyle(
          color: green,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    child:PopScope(
      canPop: !widget.isRequired,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Children'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 36, 118, 0),
          foregroundColor: Colors.white,
          automaticallyImplyLeading: !widget.isRequired,
        ),

        //  background 
        body: Container(
          color: const Color.fromARGB(255, 187, 205, 187),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Add new child button 
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _showAddChildDialog,
                    icon: const Icon(Icons.add_circle),
                    label: const Text('Add New Child'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 36, 118, 0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Children list updates automatically using Hive listener
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: childBox.listenable(),
                    builder: (context, Box<Child> box, _) {
                      if (box.isEmpty) {
                        return Center(
                          child: Text(
                            'No children added yet',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 0, 78, 6),
                              fontSize: 16,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: box.length,
                        itemBuilder: (context, index) {
                          final child = box.getAt(index);
                          final name = child?.name ?? 'Unknown';
                          final isSelected =
                              widget.account.currentChild == name;

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            color: isSelected
                                ? const Color(0xFFE8F5E9)
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: isSelected
                                    ? Colors.green
                                    : Colors.grey.shade300,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: ListTile(
                              onTap: () =>
                                  _selectChildWithPassword(name),

                              leading: ChildAvatar(name, size: 60),

                              title: Text(
                                name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              subtitle: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Age: ${child?.getAge()} years'),

                                  // Highlight current child
                                  if (isSelected)
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 36, 118, 0),
                                        borderRadius:
                                            BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'Current Child',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),

                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Color(0xFFFF6347), 
                                ),
                                onPressed: () =>
                                    _deleteChildWithPassword(
                                  index,
                                  name,
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
    ),);
  }

  // Select a child after password verification
  void _selectChild(String childName) {
    widget.account.setCurrentChild(childName);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$childName is now the current child')),
    );

    // Navigate back to main app after selection
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MainApp()),
        );
      }
    });
  }

  void _selectChildWithPassword(String childName) {
    _showPasswordDialog(
      title: 'Change Child',
      onConfirm: () => _selectChild(childName),
    );
  }

  void _deleteChildWithPassword(int index, String name) {
    _showPasswordDialog(
      title: 'Delete Child',
      onConfirm: () => _deleteChild(index, name),
    );
  }

  // Common password validation dialog
  void _showPasswordDialog({
    required String title,
    required VoidCallback onConfirm,
  }) {
    final controller = TextEditingController();

    showDialog(
    context: context,
    builder: (dialogContext) => Theme(
      data: Theme.of(context).copyWith(

        // removes purple default colors
        colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: const Color.fromARGB(255, 0, 93, 28),
          secondary: const Color.fromARGB(255, 0, 93, 28),
        ),

        
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color.fromARGB(255, 0, 93, 28),
          selectionHandleColor: Color.fromARGB(255, 0, 93, 28),
          selectionColor: Color.fromARGB(255, 0, 93, 28),
        ),
      ),

    
    child:AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 0, 149, 5),
                      width: 1.5,
                    ),
                  ),

            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 0, 130, 4),
                width: 2,
              ),
            ),
          ),
        ),
        actions: [
          // Close dialog safely
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel',
               style: TextStyle(color: Color.fromARGB(255, 0, 93, 28))),
          ),

          ElevatedButton(
            onPressed: () {
            final password = controller.text.trim();

            if (password.isEmpty) {
              showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                title: const Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red,
                    ),
                    SizedBox(width: 8),
                    Text("Warning"),
                  ],
                ),
                content: const Text(
                  "Incorrect password!",
                  style: TextStyle(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "OK",
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 93, 28),
                      ),
                    ),
                  ),
                ],
              ),
            );
              return;
            }

            if (widget.account.verifyPassword(password)) {
              Navigator.of(dialogContext).pop();
              onConfirm();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  content: const Center(
                    child: Text(
                      "Incorrect password!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }
          },
            child: const Text('Confirm',
               style: TextStyle(color: Color.fromARGB(255, 0, 93, 28))),
          ),
        ],
      ),
    ),);
  }

  // Delete child from Hive storage
  void _deleteChild(int index, String name) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Child'),
        content: Text('Delete $name?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel',
               style: TextStyle(color: Color.fromARGB(255, 0, 93, 28))),
          ),
          ElevatedButton(
            onPressed: () {
              childBox.deleteAt(index);

              if (widget.account.currentChild == name) {
                widget.account.setCurrentChild('');
              }

              Navigator.of(dialogContext).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$name deleted')),
              );

              setState(() {});
            },
            child: const Text('Delete',
               style: TextStyle(color: Color.fromARGB(255, 0, 93, 28))),
          ),
        ],
      ),
    );
  }

  // verify password before adding new child
  void _showAddChildDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => Theme(
      data: Theme.of(context).copyWith(

        // removes purple default colors
        colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: const Color.fromARGB(255, 0, 93, 28),
          secondary: const Color.fromARGB(255, 0, 93, 28),
        ),

        
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color.fromARGB(255, 0, 93, 28),
          selectionHandleColor: Color.fromARGB(255, 0, 93, 28),
          selectionColor: Color.fromARGB(255, 0, 93, 28),
        ),
      ),

    
    child:AlertDialog(
        title: const Text('Verify Password'),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 0, 149, 5),
                      width: 1.5,
                    ),
                  ),

            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 0, 130, 4),
                width: 2,
              ),
          ),
        ),),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(),
            child: const Text('Cancel',
               style: TextStyle(color: Color.fromARGB(255, 0, 93, 28))),
          ),
          ElevatedButton(
            onPressed: () {
              if (widget.account.verifyPassword(controller.text)) {
                Navigator.of(dialogContext).pop();
                _showChildFormDialog();
              }
            },
            child: const Text('Verify',
               style: TextStyle(color: Color.fromARGB(255, 0, 93, 28))),
          ),
        ],
      ),
    ),);
  }

  // Form to add a new child
  void _showChildFormDialog() {
    final nameController = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Theme(
        data: Theme.of(context).copyWith(

          // removes purple default colors
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: const Color.fromARGB(255, 0, 93, 28),
            secondary: const Color.fromARGB(255, 0, 93, 28),
          ),

          
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color.fromARGB(255, 0, 93, 28),
            selectionHandleColor: Color.fromARGB(255, 0, 93, 28),
            selectionColor: Color.fromARGB(255, 0, 93, 28),
          ),
        ),

      
      child:AlertDialog(
          title: const Text('Child Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Child Name',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 0, 93, 28),),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 0, 149, 5),
                      width: 1.5,
                    ),
                  ),

                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 0, 130, 4),
                      width: 2,
                    ),
                  ),
                ),
                
              ),
              const SizedBox(height: 12),

              // Date of birth picker
              TextButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),  // earliest date user allowed to pick
                    lastDate: DateTime.now(),
                    // calendar theme
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Colors.green, // header + selected date
                            onPrimary: Colors.white,
                            onSurface: Color.fromARGB(255, 0, 93, 28), // text color
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() => selectedDate = picked);
                  }
                },
                child: Text(
                  selectedDate == null
                      ? 'Select DOB'
                      : 'DOB: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 0, 93, 28),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel',
               style: TextStyle(color: Color.fromARGB(255, 0, 93, 28))),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();

                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter the child's name."),
                    ),
                  );
                  return;
                }

                if (selectedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select the child's date of birth."),
                    ),
                  );
                  return;
                }
                

                // Check for duplicate child name
                final exists = childBox.values.any(
                  (child) => child.name.toLowerCase() == name.toLowerCase(),
                );

                if (exists) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("A child with this name already exists."),
                    ),
                  );
                  return;
                }
                // Create the child only after validation passes
                try {
                  final child = Child.create(
                    name: name,
                    dob: selectedDate!,
                  );

                  childBox.add(child);
                  widget.account.setCurrentChild(child.name);

                  Navigator.pop(context);
                  setState(() {});
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
                }
              },
              child: const Text('Add',
               style: TextStyle(color: Color.fromARGB(255, 0, 93, 28))),
            ),
          ],
        ),
      ),
    ),);
  }
}